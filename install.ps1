$ErrorActionPreference = "Stop"

# Inputs: env override wins, else the values baked in at release time by
# `atomy-toolkit package bootstrap` (which replaces the __WHEEL_*__ tokens).
$WheelUrl = $env:ATOMY_TOOLKIT_WHEEL_URL; if (-not $WheelUrl) { $WheelUrl = "https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/atomy_toolkit_lib-0.8.0-py3-none-any.whl" }
$WheelSha = $env:ATOMY_TOOLKIT_WHEEL_SHA256; if (-not $WheelSha) { $WheelSha = "b80af6110cc45b3e1f844e38f22edd870a008bdd2480a8cb93c4abe4cb857819" }
$Root = if ($env:ATOMY_TOOLKIT_INSTALL_ROOT) { $env:ATOMY_TOOLKIT_INSTALL_ROOT } else { Join-Path $HOME "atomy-toolkit" }
$CodingTool = if ($env:ATOMY_TOOLKIT_CODING_TOOL) { $env:ATOMY_TOOLKIT_CODING_TOOL } else { "codex" }
$IdeTool = if ($env:ATOMY_TOOLKIT_IDE_TOOL) { $env:ATOMY_TOOLKIT_IDE_TOOL } else { "skip" }

if ($WheelUrl -eq "__WHEEL_URL__" -or -not $WheelUrl) {
  throw "wheel URL not set. Build a release bootstrap with 'atomy-toolkit package bootstrap', or set ATOMY_TOOLKIT_WHEEL_URL."
}
if ($WheelSha -eq "__WHEEL_SHA256__" -or -not $WheelSha) {
  throw "wheel SHA256 not set (set ATOMY_TOOLKIT_WHEEL_SHA256)."
}

if ($CodingTool -notin @("codex", "skip") -or $IdeTool -notin @("antigravity", "skip")) {
  throw "지원하지 않는 설치 선택입니다: $CodingTool / $IdeTool"
}

function Test-PyOk([string]$exe) {
  if (-not $exe) { return $false }
  $cmd = Get-Command $exe -ErrorAction SilentlyContinue
  if (-not $cmd) { return $false }
  & $cmd.Source -c "import sys; raise SystemExit(0 if sys.version_info[:2] >= (3,12) else 1)" 2>$null
  return ($LASTEXITCODE -eq 0)
}

function Invoke-NativeChecked {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Executable,
    [Parameter(Mandatory = $true)]
    [string[]]$ArgumentList,
    [Parameter(Mandatory = $true)]
    [string]$FailureMessage
  )

  & $Executable @ArgumentList
  $exitCode = $LASTEXITCODE
  if ($exitCode -ne 0) {
    throw "$FailureMessage (exit $exitCode)"
  }
}

# --- Resolve a Python >= 3.12. The wheel is ALWAYS installed into an isolated
#     venv ($Root\.runtimes\install-*) — never system-site / --user (PEP 668 + editable shadow). ---
$venvDir = $null
$basePy = $null   # system interpreter that bootstraps the venv (uv 미사용 경로)
$runPy = $null    # interpreter available NOW for the download/sha helpers
$useUv = $false
$uv = $null
$pythonInstallHelp = "Install Python 3.12+ from https://www.python.org/downloads/. Alternatively, install uv separately using its official instructions at https://docs.astral.sh/uv/getting-started/installation/, then ensure uv is on PATH or set ATOMY_TOOLKIT_UV_BIN and rerun this installer."

# --- Python 3.12+ 도 uv 도 없으면 묻지 않고 uv 를 받는다 (D-108, 2026-11-18 소유자 결정). ---
# 판을 고정하고, 받은 파일을 아래 확인값과 대조한 뒤에만 실행한다. 설치 스크립트를 받아 바로 실행하지
# 않는다(0.4.0 의 거부가 막던 것). 관리자 권한 없이 사용자 폴더(~\.local\bin)에 둔다 — 차단 훅이 그 자리를
# 직접 본다. 판·확인값을 바꿀 때는 install-cli.sh 와 함께 바꾼다(시험이 두 파일을 대조한다).
$UvVersion = "0.13.7"
$UvHomeBin = Join-Path (Join-Path (Join-Path $HOME ".local") "bin") "uv.exe"
$UvPinnedSha = @{
  "x86_64-pc-windows-msvc" = "0cdc5b38fe5a8168ed6a25814f5ba43c21d313dd3187314fccb37b7cec46e021"
  "aarch64-pc-windows-msvc" = "505d9e65e7692bac3ddf98c66754aa26c5050c409c184af30a881a0a72cc85e3"
}

function Get-UvTarget {
  $arch = $null
  try { $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString() } catch { $arch = $null }
  if (-not $arch) { $arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE } }
  switch -Regex ("$arch") {
    '^(X64|AMD64)$' { return "x86_64-pc-windows-msvc" }
    '^(Arm64|ARM64)$' { return "aarch64-pc-windows-msvc" }
    default { return "" }
  }
}

function Stop-UvFetch([string]$reason) {
  Write-Host "Python 3.12 이상과 uv 가 없어 uv 를 자동으로 받으려 했지만 못 했습니다: $reason"
  Write-Host "다음에 할 일: 아래 안내대로 Python 3.12 이상을 직접 설치한 뒤 이 설치 명령을 다시 실행하세요."
  throw "$reason $pythonInstallHelp"
}

function Get-PinnedUv {
  $target = Get-UvTarget
  if (-not $target) { Stop-UvFetch "this computer type has no pinned uv checksum" }
  $expected = if ($env:ATOMY_TOOLKIT_UV_SHA256) { $env:ATOMY_TOOLKIT_UV_SHA256 } else { $UvPinnedSha[$target] }
  $base = if ($env:ATOMY_TOOLKIT_UV_DOWNLOAD_BASE) { $env:ATOMY_TOOLKIT_UV_DOWNLOAD_BASE.TrimEnd("/") } else { "https://github.com/astral-sh/uv/releases/download/$UvVersion" }
  $url = "$base/uv-$target.zip"
  if ($env:ATOMY_TOOLKIT_UV_SHA256 -or $env:ATOMY_TOOLKIT_UV_DOWNLOAD_BASE) {
    Write-Host "WARNING: 설정값으로 uv 확인값 또는 받는 주소를 바꿨습니다 (ATOMY_TOOLKIT_UV_SHA256 / ATOMY_TOOLKIT_UV_DOWNLOAD_BASE)."
  }
  $tmpRoot = if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
  $work = New-Item -ItemType Directory -Path (Join-Path $tmpRoot ("uv-" + [guid]::NewGuid()))
  try {
    $archive = Join-Path $work "uv-$target.zip"
    Write-Host "Python 3.12 이상과 uv 가 없어 uv $UvVersion ($target) 을 받습니다: $url"
    Write-Host "  관리자 권한 없이 $UvHomeBin 에 둡니다. 원래 있던 Python 은 건드리지 않습니다."
    try {
      if ($url.StartsWith("file://")) {
        Copy-Item -LiteralPath ([Uri]$url).LocalPath -Destination $archive
      } else {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing -TimeoutSec 600
      }
    } catch {
      Stop-UvFetch "uv download failed (network or company firewall may be blocking github.com)"
    }
    $actual = (Get-FileHash $archive -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne "$expected".ToLowerInvariant()) {
      Stop-UvFetch "uv SHA256 mismatch. expected=$expected actual=$actual"
    }
    $unpacked = Join-Path $work "unpacked"
    Expand-Archive -LiteralPath $archive -DestinationPath $unpacked -Force
    $exe = Join-Path $unpacked "uv.exe"
    if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { Stop-UvFetch "uv archive has an unexpected layout" }
    $binDir = Split-Path -Parent $UvHomeBin
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
    $staged = "$UvHomeBin.tmp.$PID"
    Copy-Item -LiteralPath $exe -Destination $staged -Force
    Move-Item -LiteralPath $staged -Destination $UvHomeBin -Force
    Write-Host "받음: uv $UvVersion ($target, 확인값 일치) → $UvHomeBin"
  } finally {
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
  }
}

# ARM 기기의 Windows 에서는 툴킷 부품 일부(cryptography)의 ARM 용 완성본이 없어 원본 빌드를 시도하다 실패한다
# (2026-11-19 Parallels 실측). uv 에게 x64 Python 을 받게 한다 — ARM Windows 는 x64 를 에뮬레이션으로 돌린다.
$UvPythonRequest = if ((Get-UvTarget) -eq "aarch64-pc-windows-msvc") { "cpython-3.12-windows-x86_64-none" } else { "3.12" }

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
  if (-not $uv -and (Test-Path -LiteralPath $UvHomeBin -PathType Leaf)) {
    $uv = $UvHomeBin
    $reusedVersion = try { (& $uv --version 2>$null) } catch { "판 확인 불가" }
    Write-Host "이미 받아 둔 uv 를 씁니다: $uv ($reusedVersion)"
  }
  if (-not $uv) {
    if ($env:ATOMY_TOOLKIT_DRY_RUN -eq "1") {
      Write-Host "dry-run ok (python missing; would download uv $UvVersion to $UvHomeBin)"
      exit 0
    }
    Get-PinnedUv
    $uv = $UvHomeBin
  }
  $useUv = $true
}

# --- Download the wheel (preserve its real PEP 427 filename) + verify SHA256. ---
# $env:TEMP is Windows-only; use a cross-platform temp base so pwsh on Linux/macOS works.
$tmpBase = if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
$tmp = New-Item -ItemType Directory -Path (Join-Path $tmpBase ([guid]::NewGuid()))
try {
  if ($useUv) {
    $helperDir = Join-Path $tmp "python"
    Invoke-NativeChecked `
      -Executable $uv `
      -ArgumentList @("venv", "--python", $UvPythonRequest, $helperDir) `
      -FailureMessage "failed to create isolated venv with uv"
    $helperPy = Join-Path $helperDir "Scripts\python.exe"
    $pyVersion = try { (& $helperPy -c "import platform; print(platform.python_version())" 2>$null) } catch { "?" }
    $uvVersionLine = try { (& $uv --version 2>$null) } catch { "uv" }
    Write-Host "마련함: Python $pyVersion (uv 가 받아 사용자 폴더에 둠, $uvVersionLine)"
  }
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
  # `[mcp]` extra 포함 — MCP server 는 toolkit 워크플로(/rpi 등)의 1순위 진입점이라
  # 선택 부품이 아니다. 빠지면 슬래시 명령이 조용히 CLI fallback 으로만 돈다
  # (2026-08-19 진단). pip·uv 모두 wheel 경로 뒤 extras 표기를 받는다 (실측).
  # 새 실행 공간을 사용하므로 실행 중인 옛 설치본이 바뀌지 않는다.
  $venvDir = Join-Path (Join-Path $Root ".runtimes") ("install-" + [guid]::NewGuid())
  $venvPy = Join-Path $venvDir "Scripts\python.exe"
  $wheelWithExtras = $wheel + "[mcp]"
  if ($useUv) {
    Invoke-NativeChecked `
      -Executable $uv `
      -ArgumentList @("venv", "--python", $UvPythonRequest, $venvDir) `
      -FailureMessage "failed to create isolated venv with uv"
    Invoke-NativeChecked `
      -Executable $uv `
      -ArgumentList @("pip", "install", "--python", $venvPy, $wheelWithExtras) `
      -FailureMessage "failed to install Atomy Toolkit wheel with uv"
  } else {
    Invoke-NativeChecked `
      -Executable $basePy `
      -ArgumentList @("-m", "venv", $venvDir) `
      -FailureMessage "failed to create isolated venv"
    $venvPy = Join-Path $venvDir "Scripts\python.exe"
    Invoke-NativeChecked `
      -Executable $venvPy `
      -ArgumentList @("-m", "pip", "install", "--upgrade", "pip>=26.1.2,<27") `
      -FailureMessage "failed to upgrade pip in isolated venv"
    Invoke-NativeChecked `
      -Executable $venvPy `
      -ArgumentList @("-m", "pip", "install", $wheelWithExtras) `
      -FailureMessage "failed to install Atomy Toolkit wheel"
  }

  # -P: cwd 를 sys.path 에 넣지 않는다. 설치기를 개발 저장소 안에서 실행해도
  # 그곳의 atomy_toolkit/ 사본이 방금 설치한 wheel 을 가리지 못하게 한다.
  Invoke-NativeChecked `
    -Executable $venvPy `
    -ArgumentList @(
      "-P",
      "-m",
      "atomy_toolkit.cli",
      "self-install",
      "--root",
      $Root,
      "--coding-tool",
      $CodingTool,
      "--ide-tool",
      $IdeTool
    ) `
    -FailureMessage "failed to configure Atomy Toolkit installation"

  # Warn on a stale 'atomy-toolkit' shadow, then drop a stable shim that points
  # at the venv entry point (%LOCALAPPDATA%\atomy-toolkit\bin\atomy-toolkit.cmd).
  $venvExe = Join-Path $venvDir "Scripts\atomy-toolkit.exe"
  $existing = (Get-Command atomy-toolkit -ErrorAction SilentlyContinue).Source
  if ($existing -and $existing -ne $venvExe) {
    Write-Host "WARNING: existing 'atomy-toolkit' on PATH ($existing) may shadow this install; replacing the shim to point at the venv."
  }
  $shimDir = Join-Path $env:LOCALAPPDATA "atomy-toolkit\bin"
  # 자동화(테스트·CI)는 이 스위치로 영속 PATH 쓰기를 끈다. 매 실행마다 shim 경로가
  # 달라지는 환경에서는 아래의 '같은 경로면 중복 제거' 방어가 통하지 않아 죽은 항목이
  # 사용자 PATH 에 무한히 쌓인다 (2026-08-07 실측: 임시경로 4건 누적).
  $skipPathUpdate = ($env:ATOMY_TOOLKIT_SKIP_PATH_UPDATE -eq "1")
  New-Item -ItemType Directory -Force -Path $shimDir | Out-Null
  $shim = Join-Path $shimDir "atomy-toolkit.cmd"
  if (Test-Path -LiteralPath $shim -PathType Container) { throw "실행 연결 위치가 폴더입니다." }
  if (Test-Path -LiteralPath $shim) {
    $backup = Join-Path (Join-Path $Root ".toolkit-install-backups") ("command-" + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    Copy-Item -LiteralPath $shim -Destination $backup
  }
  $shimTemporary = Join-Path $shimDir (".atomy-toolkit-" + [guid]::NewGuid())
  try {
    $shimText = "@echo off`r`nchcp 65001 >nul`r`n`"$venvExe`" %*`r`n"
    [IO.File]::WriteAllText($shimTemporary, $shimText, [Text.UTF8Encoding]::new($false))
    if (Test-Path -LiteralPath $shim) {
      [IO.File]::Replace($shimTemporary, $shim, $null)
    } else {
      [IO.File]::Move($shimTemporary, $shim)
    }
  } finally {
    if (Test-Path -LiteralPath $shimTemporary) { Remove-Item -LiteralPath $shimTemporary }
  }

  # Put the stable shim first so an older global console script cannot shadow it.
  # Preserve every unrelated user PATH entry and keep the update idempotent.
  # 두 플랫폼 모두 실행 연결을 만들고 영속 PATH 안내·등록만 건너뛴다.
  if ($skipPathUpdate) {
    Write-Host "ATOMY_TOOLKIT_SKIP_PATH_UPDATE=1 - skipping persistent PATH update."
    Write-Host "Shim remains at $shim (add $shimDir to PATH to use)."
  } else {
    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $userPathEntries = @(
      $currentUserPath -split ';' |
        Where-Object { $_ -and $_.TrimEnd('\') -ine $shimDir.TrimEnd('\') }
    )
    $newUserPath = (@($shimDir) + $userPathEntries) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
  }
  $processPathEntries = @(
    $env:PATH -split ';' |
      Where-Object { $_ -and $_.TrimEnd('\') -ine $shimDir.TrimEnd('\') }
  )
  $env:PATH = (@($shimDir) + $processPathEntries) -join ';'

  Write-Host "Done. Atomy Toolkit installed to $Root (venv: $venvDir)"
  Write-Host "Command path activated: $shim"
  # QOL #5 (2026-08-28): 설치 직후 "이제 뭐부터?" 다음 3단계 안내
  Write-Host ""
  Write-Host "다음 3단계:"
  Write-Host "  1) 프로젝트 폴더에서: atomy-toolkit install .   (작업 규칙 설치)"
  Write-Host "  2) AI 도구에서 /rpi 를 입력해 첫 작업을 시작하세요"
  Write-Host "  3) 막히면 /sos 에 오류를 붙여넣으세요 (쉬운 말 번역)"
} finally {
  Remove-Item -Recurse -Force $tmp
}
