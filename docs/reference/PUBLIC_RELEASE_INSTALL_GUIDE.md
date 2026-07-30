# Atomy Toolkit v0.4.0 Public Release Install Guide

This guide documents the public, clean-slate Atomy Toolkit artifact channel.

- Private source repository: `suhwang-atomy/_global-toolkit`
- Public release repository:
  <https://github.com/suhwang-atomy/_global-toolkit-releases>
- Current release:
  [v0.4.0](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.4.0)
- Exact source commit: `f321cc47045bec5c0b08f05163fec2e44bc408f4`

## Supported release assets

The v0.4.0 GitHub Release contains exactly these four assets:

| Asset | SHA256 |
|---|---|
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` | `bd90615f04c647a0d3e004ea75e65bb18bad3467a335316b0d9883c079c2043a` |
| `SHA256.txt` | `563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d` |
| `install-cli.sh` | `c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc` |
| `install-cli.ps1` | `0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804` |

No native `.exe`, `.pkg`, `.dmg`, or `.AppImage` belongs to the supported
v0.4.0 channel.

`SHA256.txt` lists the wheel and both command installers. It cannot contain a
stable checksum of itself, so its own checksum is anchored in the release
documentation above.

## Prerequisite

Before running an installer, provide either:

- Python 3.12 or newer on `PATH`; or
- `uv` already installed on `PATH`, or supplied through
  `ATOMY_TOOLKIT_UV_BIN`.

If Python is unavailable, preinstalled `uv` may provision Python 3.12. The
bootstrap never downloads or executes a Python or `uv` installer. It fails
closed if neither prerequisite is available and links to:

- <https://www.python.org/downloads/>
- <https://docs.astral.sh/uv/getting-started/installation/>

## Safe pinned install

Never pipe a remote script directly into a shell. Download the exact v0.4.0
asset, verify it, and execute the verified local file.

### Linux

<!-- markdownlint-disable MD013 -->

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

### macOS

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

### Windows 11 PowerShell

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.ps1 -OutFile install-cli.ps1
$expected = "0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

<!-- markdownlint-enable MD013 -->

The command installers contain the pinned wheel URL and
`bd90615f04c647a0d3e004ea75e65bb18bad3467a335316b0d9883c079c2043a`. They download that wheel, verify its bytes,
create an isolated virtual environment, install the wheel, and run
`atomy-toolkit self-install`.

## Verify all downloaded assets

Download `SHA256.txt` and the three payloads into one directory:

<!-- markdownlint-disable MD013 -->

```bash
base=https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0
curl -fLO "$base/SHA256.txt"
curl -fLO "$base/atomy_toolkit_lib-0.4.0-py3-none-any.whl"
curl -fLO "$base/install-cli.sh"
curl -fLO "$base/install-cli.ps1"
echo "563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d  SHA256.txt" | sha256sum -c -
sha256sum -c SHA256.txt
```

On macOS, use `shasum -a 256 -c -` and `shasum -a 256 -c SHA256.txt`.

Windows PowerShell:

```powershell
$base = "https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0"
Invoke-WebRequest "$base/SHA256.txt" -OutFile SHA256.txt
Invoke-WebRequest "$base/atomy_toolkit_lib-0.4.0-py3-none-any.whl" -OutFile atomy_toolkit_lib-0.4.0-py3-none-any.whl
Invoke-WebRequest "$base/install-cli.sh" -OutFile install-cli.sh
Invoke-WebRequest "$base/install-cli.ps1" -OutFile install-cli.ps1
$shaFileExpected = "563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d"
$shaFileActual = (Get-FileHash .\SHA256.txt -Algorithm SHA256).Hash.ToLowerInvariant()
if ($shaFileActual -ne $shaFileExpected) { throw "SHA256.txt mismatch" }
Get-Content .\SHA256.txt | Where-Object { $_ -match "^[0-9a-f]{64}\s+" } | ForEach-Object {
  $expected, $name = $_ -split "\s+", 2
  $path = $name.Trim()
  $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($actual -ne $expected) { throw "SHA256 mismatch: $path" }
}
```

<!-- markdownlint-enable MD013 -->

## Installation result

The bootstrap installs into an isolated virtual environment under the selected
Toolkit root; it does not modify system site-packages.

Verify:

```bash
atomy-toolkit --version
atomy-toolkit doctor
atomy-toolkit graph --help
atomy-toolkit afk --help
```

The version must report `0.4.0`.

## Compliance and privacy

- The project is distributed under the [MIT License](../../LICENSE).
- Adapted engineering-discipline material is attributed in
  [NOTICE](../../NOTICE).
- [Graph Report third-party notices](../../THIRD_PARTY_NOTICES.md) cover 35
  runtime-bundled package records. The runtime licenses are MIT, ISC, and
  BSD-3-Clause; installed MPL-licensed package records are `0`.
- Clean-slate packaging excludes private source history, credentials, user
  memory, Graph data, session/log state, backups, and in-flight project
  documents.
- The public artifacts are unsigned. The pinned SHA256 values are the integrity
  control.

## Infrastructure scope

The DGX used during Knowledge Fabric testing was another temporarily available
PC, not an operating server.

A future centralized service may batch embedding work for Memtemple records
provided by Toolkit users. Railway or AWS hosting, and a possible cascade
patch/update service, are separate future projects. They are not deployed or
operated by v0.4.0.

## Operator release flow

1. Build from exact private source commit
   `f321cc47045bec5c0b08f05163fec2e44bc408f4` in a clean checkout.
   Set `SOURCE_DATE_EPOCH=1785391413`, the source commit timestamp, for the
   wheel build. A second clean build must produce the same wheel SHA256.
2. Run the final Python, Graph, package, leak, license, and isolated-install
   release gates once at the release boundary.
3. Produce only:
   - `atomy_toolkit_lib-0.4.0-py3-none-any.whl`
   - `SHA256.txt`
   - `install-cli.sh`
   - `install-cli.ps1`
4. Replace every `FINAL_*_PLACEHOLDER` in public documentation and bootstrap
   files with the final source commit or asset checksum.
5. Confirm that no placeholder, private path, credential, user memory, or
   source archive remains.
6. Merge the public documentation branch and create the v0.4.0 GitHub Release
   with exactly those four assets.
7. Download all four assets from the public release and repeat checksum and
   isolated-install verification against the public URLs.

Do not tag the private source repository to invoke an unrelated native
installer workflow. The v0.4.0 public channel is the wheel-and-command
installer channel described here.
