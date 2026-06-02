# Atomy Toolkit Command Install

macOS / Linux:

```bash
curl -fsSL https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.sh | sh
```

Windows 11 PowerShell:

```powershell
irm https://github.com/suhwang-atomy/_global-toolkit-releases/raw/main/install.ps1 | iex
```

The bootstrap checks for Python 3.12+. If it is missing, the script installs `uv`, provisions Python 3.12, downloads the latest `atomy_toolkit_lib-*.whl` release asset, verifies SHA256, installs the wheel into `~/atomy-toolkit/.venv`, and runs:

```bash
atomy-toolkit self-install
```

If Python bootstrap fails on macOS, install Python 3.12+ first, then run the same command again.

Optional environment variables:

| Variable | Purpose |
|---|---|
| `ATOMY_TOOLKIT_INSTALL_ROOT` | Install root. Default: `~/atomy-toolkit`. |
| `ATOMY_TOOLKIT_CODING_TOOL` | `codex` or `skip`. Default: `codex`. |
| `ATOMY_TOOLKIT_IDE_TOOL` | `vscode`, `antigravity`, or `skip`. Default: `skip`. |
| `ATOMY_TOOLKIT_RELEASE_REPO` | GitHub release repo. Default: `suhwang-atomy/_global-toolkit-releases`. |
| `ATOMY_TOOLKIT_WHEEL_URL` | Override wheel URL for testing or pinned installs. |
| `ATOMY_TOOLKIT_WHEEL_SHA256` | Expected SHA256 for the override wheel. |
