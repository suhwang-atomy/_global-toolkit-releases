# Atomy Toolkit Public Release Install Guide

This guide documents the public artifact channel for clean-slate Atomy Toolkit installer builds.

Source code remains in the private repository:

- `suhwang-atomy/_global-toolkit`

Installer artifacts are published in the public release repository:

- `https://github.com/suhwang-atomy/_global-toolkit-releases`

Current release:

- `v0.1.0`
- Release page: `https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.1.0`
- Source workflow run: `https://github.com/suhwang-atomy/_global-toolkit/actions/runs/26396236791`
- Source commit: `4ab32973bace054545aaed9d996d191b14d5b922`

## One-Line Command Install

macOS / Linux:

```bash
curl -fsSL https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.sh | sh
```

Windows 11 PowerShell:

```powershell
irm https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.ps1 | iex
```

The bootstrap script checks for Python 3.12+, provisions it with `uv` when it is missing, discovers the latest `atomy_toolkit_lib-*.whl` release asset, verifies the published SHA256, installs the wheel into `~/atomy-toolkit/.venv`, and runs `atomy-toolkit self-install`.

If Python bootstrap fails on macOS, install Python 3.12+ first, then run the same command again.

## Direct Downloads

### Windows

PowerShell:

```powershell
curl.exe -L `
  -o AtomyToolkit-Setup-0.1.0.exe `
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-0.1.0.exe
```

Verify:

```powershell
Get-FileHash -Algorithm SHA256 .\AtomyToolkit-Setup-0.1.0.exe
```

Expected SHA256:

```text
C5215D207DBE4C174A98F4F64966253A7B9FC669B6FAB083684857A301528FA7
```

### macOS pkg

```bash
curl -L \
  -o AtomyToolkit-Setup-macOS-0.1.0.pkg \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-macOS-0.1.0.pkg
```

Verify:

```bash
shasum -a 256 AtomyToolkit-Setup-macOS-0.1.0.pkg
```

Expected SHA256:

```text
8AC9F79A2444820B85AE7BBAE9FFCEECEE9A5FCF1A965C5B34DA4AEDCFD0702E
```

### macOS dmg

```bash
curl -L \
  -o AtomyToolkit-Setup-macOS-0.1.0.dmg \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-macOS-0.1.0.dmg
```

Verify:

```bash
shasum -a 256 AtomyToolkit-Setup-macOS-0.1.0.dmg
```

Expected SHA256:

```text
B8F0D8E88B27F9644348DFFD5CE704C631AF6ABD3FF1DF3CF4107BCC70E9F3D1
```

### Checksum File

```bash
curl -L \
  -o SHA256SUMS.txt \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/SHA256SUMS.txt
```

## Current Signing Status

The `v0.1.0` artifacts are unsigned public test artifacts.

- Windows may show SmartScreen or publisher warnings.
- macOS may require manual approval because the `.pkg` and `.dmg` are not signed or notarized.
- Treat SHA256 verification as the integrity check for this unsigned release.

## Operator Release Flow

1. Build clean-slate installer artifacts from the private source repository using the `Release Installers` GitHub Actions workflow.
2. Download the successful workflow artifacts.
3. Compute SHA256 checksums for every public artifact.
4. Upload only release artifacts and checksum files to `suhwang-atomy/_global-toolkit-releases`.
5. Keep private source archives, logs, credentials, generated local memory, and package staging internals out of the public release repository.

Example upload command for a replacement release:

```powershell
gh release upload v0.1.0 `
  .\AtomyToolkit-Setup-0.1.0.exe `
  .\AtomyToolkit-Setup-macOS-0.1.0.pkg `
  .\AtomyToolkit-Setup-macOS-0.1.0.dmg `
  .\SHA256SUMS.txt `
  --repo suhwang-atomy/_global-toolkit-releases `
  --clobber
```

## Non-Installer Alternatives

When users have access to the private source repository, pip can install directly from GitHub:

```bash
python -m pip install "git+https://github.com/suhwang-atomy/_global-toolkit.git@main"
atomy-toolkit install ./my-project --no-mempalace --no-vibe-sunsang
```

This path requires GitHub authentication while the source repository remains private.

Future public package options:

- Publish a PyPI package for `pip install atomy-toolkit-lib`.
- Publish an npm wrapper package for `npm install -g atomy-toolkit` or `npm exec`.
- Keep the small bootstrap scripts in this public release repository for command-based installs.
