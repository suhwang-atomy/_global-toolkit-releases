$ErrorActionPreference = "Stop"

$ReleaseRepo = if ($env:ATOMY_TOOLKIT_RELEASE_REPO) { $env:ATOMY_TOOLKIT_RELEASE_REPO } else { "suhwang-atomy/_global-toolkit-releases" }
$Root = if ($env:ATOMY_TOOLKIT_INSTALL_ROOT) { $env:ATOMY_TOOLKIT_INSTALL_ROOT } else { Join-Path $HOME "atomy-toolkit" }
$CodingTool = if ($env:ATOMY_TOOLKIT_CODING_TOOL) { $env:ATOMY_TOOLKIT_CODING_TOOL } else { "codex" }
$IdeTool = if ($env:ATOMY_TOOLKIT_IDE_TOOL) { $env:ATOMY_TOOLKIT_IDE_TOOL } else { "skip" }

function Test-Python312 {
  param([string]$PythonPath)
  if (-not $PythonPath) { return $false }
  try {
    & $PythonPath -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 12) else 1)" | Out-Null
    return $LASTEXITCODE -eq 0
  } catch {
    return $false
  }
}

function Find-Python312 {
  if ($env:PYTHON -and (Test-Python312 $env:PYTHON)) {
    return $env:PYTHON
  }
  $cmd = Get-Command python -ErrorAction SilentlyContinue
  if ($cmd -and (Test-Python312 $cmd.Source)) {
    return $cmd.Source
  }
  $cmd = Get-Command python3 -ErrorAction SilentlyContinue
  if ($cmd -and (Test-Python312 $cmd.Source)) {
    return $cmd.Source
  }
  return $null
}

function Get-TextFromUrl {
  param([string]$Url)
  $content = (Invoke-WebRequest -UseBasicParsing -Uri $Url).Content
  if ($content -is [byte[]]) {
    return [System.Text.Encoding]::UTF8.GetString($content)
  }
  return [string]$content
}

function Save-Url {
  param(
    [string]$Url,
    [string]$OutFile
  )
  Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $OutFile
}

function Install-UvPython {
  $uv = (Get-Command uv -ErrorAction SilentlyContinue).Source
  if (-not $uv) {
    Write-Host "Installing uv to provision Python 3.12..."
    irm https://astral.sh/uv/install.ps1 | iex
    $uv = (Get-Command uv -ErrorAction SilentlyContinue).Source
  }
  if (-not $uv) {
    $candidate = Join-Path $HOME ".local/bin/uv.exe"
    if (Test-Path $candidate) { $uv = $candidate }
  }
  if (-not $uv) {
    throw "uv installation finished but uv was not found."
  }
  & $uv python install 3.12
  return (& $uv python find 3.12).Trim()
}

$py = Find-Python312
if (-not $py) {
  $py = Install-UvPython
}
if (-not (Test-Python312 $py)) {
  throw "Python 3.12+ required."
}

$WheelUrl = $env:ATOMY_TOOLKIT_WHEEL_URL
$WheelSha = $env:ATOMY_TOOLKIT_WHEEL_SHA256

if (-not $WheelUrl -or -not $WheelSha) {
  $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$ReleaseRepo/releases/latest"
  $wheelAsset = $release.assets | Where-Object {
    $_.name -like "atomy_toolkit_lib-*.whl"
  } | Select-Object -First 1
  $shaAsset = $release.assets | Where-Object {
    $_.name -eq "SHA256.txt"
  } | Select-Object -First 1
  if (-not $shaAsset) {
    $shaAsset = $release.assets | Where-Object {
      $_.name -eq "SHA256SUMS.txt"
    } | Select-Object -First 1
  }
  if (-not $wheelAsset -or -not $shaAsset) {
    throw "latest release is missing atomy_toolkit_lib wheel or SHA256 asset"
  }
  $WheelUrl = $wheelAsset.browser_download_url
  $shaText = Get-TextFromUrl $shaAsset.browser_download_url
  $wheelLine = ($shaText -split "`r?`n") | Where-Object { $_ -like "*$($wheelAsset.name)*" } | Select-Object -First 1
  if ($wheelLine) {
    $match = [regex]::Match($wheelLine, "\b[0-9a-fA-F]{64}\b")
    if ($match.Success) {
      $WheelSha = $match.Value.ToLowerInvariant()
    }
  }
  if (-not $WheelSha) {
    $matches = [regex]::Matches($shaText, "\b[0-9a-fA-F]{64}\b")
    if ($matches.Count -eq 1) {
      $WheelSha = $matches[0].Value.ToLowerInvariant()
    } else {
      throw "SHA256 asset does not contain a unique hash for $($wheelAsset.name)"
    }
  }
}

$tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ([guid]::NewGuid()))
try {
  $wheelName = Split-Path -Leaf (([Uri]$WheelUrl).LocalPath)
  $wheel = Join-Path $tmp $wheelName
  if ($WheelUrl.StartsWith("file://")) {
    $uri = [Uri]$WheelUrl
    Copy-Item -LiteralPath $uri.LocalPath -Destination $wheel
  } else {
    Save-Url $WheelUrl $wheel
  }

  $actual = (Get-FileHash $wheel -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($actual -ne $WheelSha.ToLowerInvariant()) {
    throw "wheel SHA256 mismatch. expected=$WheelSha actual=$actual"
  }

  if ($env:ATOMY_TOOLKIT_DRY_RUN -eq "1") {
    Write-Host "dry-run ok (python=$py, sha verified)"
    exit 0
  }

  New-Item -ItemType Directory -Force -Path $Root | Out-Null
  $venvDir = Join-Path $Root ".venv"
  & $py -m venv $venvDir
  $venvPy = Join-Path $venvDir "Scripts\python.exe"
  if (-not (Test-Path $venvPy)) {
    throw "virtual environment Python was not created at $venvPy"
  }

  & $venvPy -m pip --version | Out-Null
  if ($LASTEXITCODE -ne 0) {
    & $venvPy -m ensurepip --upgrade
  }
  & $venvPy -m pip install --upgrade pip | Out-Null
  & $venvPy -m pip install --upgrade $wheel
  & $venvPy -m atomy_toolkit.cli self-install --root $Root --coding-tool $CodingTool --ide-tool $IdeTool
  Write-Host "Done. Atomy Toolkit installed to $Root"
} finally {
  Remove-Item -Recurse -Force $tmp
}
