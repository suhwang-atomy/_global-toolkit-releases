$ErrorActionPreference = "Stop"

# An explicit environment override wins; otherwise use the pinned public
# v0.4.0 wheel and its release checksum.
$WheelUrl = $env:ATOMY_TOOLKIT_WHEEL_URL; if (-not $WheelUrl) { $WheelUrl = "https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/atomy_toolkit_lib-0.4.0-py3-none-any.whl" }
$WheelSha = $env:ATOMY_TOOLKIT_WHEEL_SHA256; if (-not $WheelSha) { $WheelSha = "6a9097f2be443192db66fa5f038b435b391549760641878db109525330321297" }
$Root = if ($env:ATOMY_TOOLKIT_INSTALL_ROOT) { $env:ATOMY_TOOLKIT_INSTALL_ROOT } else { Join-Path $HOME "atomy-toolkit" }
$CodingTool = if ($env:ATOMY_TOOLKIT_CODING_TOOL) { $env:ATOMY_TOOLKIT_CODING_TOOL } else { "codex" }
$IdeTool = if ($env:ATOMY_TOOLKIT_IDE_TOOL) { $env:ATOMY_TOOLKIT_IDE_TOOL } else { "skip" }

if (-not $WheelUrl) {
  throw "wheel URL not set (set ATOMY_TOOLKIT_WHEEL_URL)."
}
if ($WheelSha -notmatch "^[0-9a-fA-F]{64}$") {
  throw "wheel SHA256 must contain exactly 64 hexadecimal characters."
}

function Test-PyOk([string]$exe) {
  if (-not $exe) { return $false }
  $cmd = Get-Command $exe -ErrorAction SilentlyContinue
  if (-not $cmd) { return $false }
  & $cmd.Source -c "import sys; raise SystemExit(0 if sys.version_info[:2] >= (3,12) else 1)" 2>$null
  return ($LASTEXITCODE -eq 0)
}

# --- Resolve a Python >= 3.12. The wheel is ALWAYS installed into an isolated
#     venv ($Root\.venv) — never system-site / --user (PEP 668 + editable shadow). ---
$venvDir = Join-Path $Root ".venv"
$basePy = $null   # system interpreter that bootstraps the venv (uv 미사용 경로)
$runPy = $null    # interpreter available NOW for the download/sha helpers
$useUv = $false
$uv = $null
$pythonInstallHelp = "Install Python 3.12+ from https://www.python.org/downloads/. Alternatively, install uv separately using its official instructions at https://docs.astral.sh/uv/getting-started/installation/, then ensure uv is on PATH or set ATOMY_TOOLKIT_UV_BIN and rerun this installer."

if ($env:ATOMY_TOOLKIT_FORCE_UV -ne "1") {
  foreach ($cand in @($env:PYTHON, "python", "python3")) {
    if (Test-PyOk $cand) { $basePy = (Get-Command $cand).Source; break }
  }
}

if ($basePy) {
  $runPy = $basePy
  Write-Host "Isolated venv target: $venvDir (system Python $basePy)"
} else {
  if ($env:ATOMY_TOOLKIT_NO_UV -eq "1") {
    throw "Python 3.12+ not found and uv provisioning is disabled. $pythonInstallHelp"
  }
  $uv = if ($env:ATOMY_TOOLKIT_UV_BIN) { $env:ATOMY_TOOLKIT_UV_BIN } else { (Get-Command uv -ErrorAction SilentlyContinue).Source }
  if (-not $uv) {
    throw "Python 3.12+ not found and uv is not installed; refusing unverified automatic provisioning. $pythonInstallHelp"
  }
  Write-Host "Provisioning Python 3.12 via uv (venv: $venvDir)..."
  & $uv venv --python 3.12 $venvDir
  $runPy = Join-Path $venvDir "Scripts\python.exe"
  $useUv = $true
}

# --- Download the wheel (preserve its real PEP 427 filename) + verify SHA256. ---
# $env:TEMP is Windows-only; use a cross-platform temp base so pwsh on Linux/macOS works.
$tmpBase = if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
$tmp = New-Item -ItemType Directory -Path (Join-Path $tmpBase ([guid]::NewGuid()))
try {
  $wheelName = Split-Path -Leaf (([Uri]$WheelUrl).LocalPath)
  $wheel = Join-Path $tmp $wheelName
  if ($WheelUrl.StartsWith("file://")) {
    Copy-Item -LiteralPath ([Uri]$WheelUrl).LocalPath -Destination $wheel
  } else {
    Invoke-WebRequest -Uri $WheelUrl -OutFile $wheel
  }

  $actual = (Get-FileHash $wheel -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($actual -ne $WheelSha.ToLowerInvariant()) {
    throw "wheel SHA256 mismatch. expected=$WheelSha actual=$actual"
  }

  if ($env:ATOMY_TOOLKIT_DRY_RUN -eq "1") {
    Write-Host "dry-run ok (python resolved, sha verified, uv=$useUv)"
    exit 0
  }

  # --- Install the wheel into the isolated venv. system-site / --user 금지. ---
  if ($useUv) {
    & $uv pip install --python $runPy $wheel
    $venvPy = $runPy
  } else {
    & $basePy -m venv $venvDir
    $venvPy = Join-Path $venvDir "Scripts\python.exe"
    & $venvPy -m pip install --upgrade "pip>=26.1.2,<27"
    if ($LASTEXITCODE -ne 0) {
      throw "failed to upgrade pip in isolated venv"
    }
    & $venvPy -m pip install $wheel
    if ($LASTEXITCODE -ne 0) {
      throw "failed to install Atomy Toolkit wheel"
    }
  }

  # Warn on a stale 'atomy-toolkit' shadow, then drop a stable shim that points
  # at the venv entry point (%LOCALAPPDATA%\atomy-toolkit\bin\atomy-toolkit.cmd).
  $venvExe = Join-Path $venvDir "Scripts\atomy-toolkit.exe"
  $existing = (Get-Command atomy-toolkit -ErrorAction SilentlyContinue).Source
  if ($existing -and $existing -ne $venvExe) {
    Write-Host "WARNING: existing 'atomy-toolkit' on PATH ($existing) may shadow this install; replacing the shim to point at the venv."
  }
  $shimDir = Join-Path $env:LOCALAPPDATA "atomy-toolkit\bin"
  New-Item -ItemType Directory -Force -Path $shimDir | Out-Null
  $shim = Join-Path $shimDir "atomy-toolkit.cmd"
  Set-Content -Path $shim -Value "@echo off`r`n`"$venvExe`" %*" -Encoding ascii

  & $venvPy -m atomy_toolkit.cli self-install --root $Root --coding-tool $CodingTool --ide-tool $IdeTool
  Write-Host "Done. Atomy Toolkit installed to $Root (venv: $venvDir)"
  Write-Host "Ensure $shimDir is on PATH (shim: $shim)."
} finally {
  Remove-Item -Recurse -Force $tmp
}
