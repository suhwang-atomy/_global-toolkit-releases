# Atomy Toolkit v0.4.0 Command Install

The supported public channel is a pinned wheel plus two small command
installers. Download the installer to a file, verify its SHA256, and only then
run that local file.

Do not connect a network download command directly to a shell or expression
evaluator.

## Prerequisite

Provide either:

- Python 3.12 or newer on `PATH`; or
- `uv` already installed on `PATH`, or its executable path in
  `ATOMY_TOOLKIT_UV_BIN`.

If Python 3.12 is unavailable, a preinstalled `uv` may provision it inside the
Toolkit virtual environment. The bootstrap never downloads or executes a
Python or `uv` installer. If neither prerequisite exists, it fails closed and
prints official installation links.

## macOS and Linux

<!-- markdownlint-disable MD013 -->

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c0f69359660310a6baeecfdc338eaecce0669a56e097a6f3c4da57653d58923c  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

On macOS, replace the verification line with:

```bash
echo "c0f69359660310a6baeecfdc338eaecce0669a56e097a6f3c4da57653d58923c  install-cli.sh" | shasum -a 256 -c -
```

<!-- markdownlint-enable MD013 -->

## Windows 11 PowerShell

<!-- markdownlint-disable MD013 -->

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.ps1 -OutFile install-cli.ps1
$expected = "b986da519b3b04725895aa82a02a03de64e802ed52db8ada98bc5aea1ca3a1ea"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

<!-- markdownlint-enable MD013 -->

## What the bootstrap does

1. Resolves Python 3.12+ or an already installed `uv`.
2. Downloads the pinned
   `atomy_toolkit_lib-0.4.0-py3-none-any.whl`.
3. Verifies the wheel against
   `6a9097f2be443192db66fa5f038b435b391549760641878db109525330321297`.
4. Installs into the isolated `atomy-toolkit/.venv`.
5. Runs `atomy-toolkit self-install`.

It does not install into system site-packages.

## Optional environment variables

| Variable | Purpose |
|---|---|
| `ATOMY_TOOLKIT_INSTALL_ROOT` | Install root. Default: `~/atomy-toolkit`. |
| `ATOMY_TOOLKIT_CODING_TOOL` | `codex` or `skip`. Default: `codex`. |
| `ATOMY_TOOLKIT_IDE_TOOL` | `vscode`, `antigravity`, or `skip`. Default: `skip`. |
| `ATOMY_TOOLKIT_UV_BIN` | Path to a preinstalled `uv` executable. |
| `ATOMY_TOOLKIT_FORCE_UV` | Set to `1` to use preinstalled `uv` even when Python 3.12 is available. |
| `ATOMY_TOOLKIT_NO_UV` | Set to `1` to forbid `uv` provisioning. |
| `ATOMY_TOOLKIT_WHEEL_URL` | Override wheel URL for an explicitly controlled test. |
| `ATOMY_TOOLKIT_WHEEL_SHA256` | Required expected SHA256 for an override wheel. |
| `ATOMY_TOOLKIT_DRY_RUN` | Set to `1` to resolve prerequisites and verify the wheel without installing. |

Wheel URL and hash overrides are intended for controlled local verification.
Always provide both and verify the source you selected.

## Confirm the installation

```bash
atomy-toolkit --version
atomy-toolkit doctor
```

The version must report `0.4.0`.

For the full four-asset hash table and checksum-file verification, see
[the public release install guide](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md).
