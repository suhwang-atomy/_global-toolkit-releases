# Atomy Toolkit Releases

Public release artifacts for Atomy Toolkit clean-slate installer builds.

The source repository remains private. This repository publishes installer files only.

Current release: [v0.1.0](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.1.0)

## One-Line Command Install

macOS / Linux:

```bash
curl -fsSL https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.sh | sh
```

Windows 11 PowerShell:

```powershell
irm https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.ps1 | iex
```

The bootstrap checks for Python 3.12+, provisions it with `uv` when missing, downloads the latest `atomy_toolkit_lib-*.whl` release asset, verifies SHA256, installs the wheel into `~/atomy-toolkit/.venv`, and runs `atomy-toolkit self-install`.

If Python bootstrap fails on macOS, install Python 3.12+ first, then run the same command again.

## Download

### Windows

```powershell
curl.exe -L `
  -o AtomyToolkit-Setup-0.1.0.exe `
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-0.1.0.exe
```

SHA256:

```text
C5215D207DBE4C174A98F4F64966253A7B9FC669B6FAB083684857A301528FA7
```

### macOS pkg

```bash
curl -L \
  -o AtomyToolkit-Setup-macOS-0.1.0.pkg \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-macOS-0.1.0.pkg
```

SHA256:

```text
8AC9F79A2444820B85AE7BBAE9FFCEECEE9A5FCF1A965C5B34DA4AEDCFD0702E
```

### macOS dmg

```bash
curl -L \
  -o AtomyToolkit-Setup-macOS-0.1.0.dmg \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/AtomyToolkit-Setup-macOS-0.1.0.dmg
```

SHA256:

```text
B8F0D8E88B27F9644348DFFD5CE704C631AF6ABD3FF1DF3CF4107BCC70E9F3D1
```

## Verify Checksums

```bash
curl -L -o SHA256SUMS.txt \
  https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.1.0/SHA256SUMS.txt
```

The v0.1.0 artifacts are unsigned. Verify the SHA256 checksum before installing.
