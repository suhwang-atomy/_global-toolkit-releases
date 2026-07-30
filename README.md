# Atomy Toolkit Releases

English | [한국어](README.ko.md)

Public, clean-slate release artifacts for Atomy Toolkit, a local-first workflow
kit for agentic software development across coding tools.

The source repository remains private. This repository contains public
installers, checksums, release documentation, and the license notices required
to redistribute the release.

> **Current release**
>
> - Latest public release:
>   [v0.4.0](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.4.0)
> - Comparison baseline: public `v0.3.1`
> - Source commit: `59a3f49dee8977edb70ff8a2f3976db9e1633d99`
> - Detailed changes: [English patch notes](PATCH_NOTES.md) ·
>   [한국어 패치 노트](PATCH_NOTES.ko.md)

## Install v0.4.0

### Prerequisite

Use either:

- Python 3.12 or newer already available on `PATH`; or
- `uv` already installed on `PATH` (or supplied with
  `ATOMY_TOOLKIT_UV_BIN`), so it can provision Python 3.12.

The installer does not download or execute a Python or `uv` installer. If
neither prerequisite is available, it stops and points to the official Python
and `uv` installation pages.

### Download, verify, then run

Do not pipe a downloaded script directly into a shell. Save the pinned v0.4.0
installer, verify it, and run the verified local file.

<!-- markdownlint-disable MD013 -->

Linux:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "1c705d7cc4c9337ff05e7ea9335980cd745fb72f3f149b5c20023f6f826b33ae  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

macOS:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "1c705d7cc4c9337ff05e7ea9335980cd745fb72f3f149b5c20023f6f826b33ae  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

Windows 11 PowerShell:

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.ps1 -OutFile install-cli.ps1
$expected = "dd9af81d6f4705d765d461798cbe14b16ed9af84da4cb9a1712a2d9572657d34"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

<!-- markdownlint-enable MD013 -->

The bootstrap downloads only the pinned
`atomy_toolkit_lib-0.4.0-py3-none-any.whl`, verifies its baked-in SHA256,
installs it into an isolated virtual environment, and runs
`atomy-toolkit self-install`. It does not install into system site-packages.

See [INSTALL.md](INSTALL.md) for options and
[the public install guide](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md) for
the complete verification flow.

## Release assets and integrity

The v0.4.0 GitHub Release has exactly four assets:

| Asset | SHA256 |
|---|---|
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` | `13743ccc648631298c9a87449fef30134cb6036f64dfde456a997d4eea694834` |
| `SHA256.txt` | `536e23217ab5216874277b9bc5a7f787065786645a4aacf50cfbf8b13ad02375` |
| `install-cli.sh` | `1c705d7cc4c9337ff05e7ea9335980cd745fb72f3f149b5c20023f6f826b33ae` |
| `install-cli.ps1` | `dd9af81d6f4705d765d461798cbe14b16ed9af84da4cb9a1712a2d9572657d34` |

`SHA256.txt` records the wheel and both command-installer hashes. Its own hash
is listed above because a checksum file cannot contain a stable checksum of
itself.

The assets are unsigned. The pinned hashes are the release integrity control.
No `.exe`, `.pkg`, `.dmg`, or `.AppImage` is part of the supported v0.4.0
channel.

## What v0.4.0 adds

Features are grouped by maturity. “Implemented” does not automatically mean
“validated in a live or production environment.”

### Verified

- **Safer project maintenance** — `cascade sync` preserves user-modified files
  using origin hashes, revalidates before writing, and reports skipped paths.
  `/new --upgrade` diagnoses first, backs up managed files, and rolls back a
  failed transaction.
- **Evidence-based workflows** — `/review` binds the diff, goal, acceptance
  criteria, verification evidence, reviewed commit, and plan bookkeeping.
  `/handoff` preserves active context and refreshes only stale configured
  Graph indexes.
- **Memtemple continuity** — the supported memory interface is
  `atomy-toolkit memtemple`; legacy Mempalace libraries and the old embedding
  shim have been retired.
- **Project Intelligence Graph** — deterministic indexes, impact queries, and
  a self-contained offline Graph Report with an approval-based judge view.
- **Browser verification dependency** — Graph Report pins Playwright `1.62.0`
  as a direct development dependency. Ubuntu CI runs Chromium browser checks;
  Playwright is not included in the runtime wheel.
- **Local controls** — opt-in, network-free command telemetry; deterministic
  audit reminders; guarded skill-intake primitives; and offline rulepack
  checks.
- **Release compliance** — clean-slate packaging excludes source history,
  credentials, local memory, and runtime state. Graph Report ships notices for
  35 runtime package records, with zero MPL-licensed installed package records.

### Preview

- **Rulepack collaboration** — a Codex/Claude two-worktree pilot completed
  locally. Remote collaboration and multi-user rollout have not been
  validated.
- **Knowledge Fabric federation** — local loopback and temporary cross-device
  transfer were tested. The DGX used in that test was simply another available
  PC and was not an operating or production server.
- **Absence Batch and Research Relay** — isolated, draft-PR-only contracts are
  implemented. Their first live external E2E and scheduled run remain pending.

### Experimental

- **`/delegate` supervised overnight automation** — the intended host is a
  capability-checked device with the Toolkit installed, such as a workstation
  left on overnight. It is not an operating-server feature. The sealed action
  table, isolated worktree, worker sandbox, controller-only credentials, and
  morning `GO`/`NO-GO` flow are implemented; the first full real overnight run
  is still pending.
- **Antigravity and Cowork adapters** — installation and capability surfaces
  exist, but additional live validation is required.
- **Skill lifecycle mutation** — APIs are fixture-tested, while automatic
  movement and promotion remain off.

Preview and experimental features are not a promise of production support.
Automation with remote effects must remain on isolated, non-default branches
and be explicitly finalized by the user.

## Important limitations

- `atomy-toolkit update` and `update rollback` are not operational package
  replacement and restore paths in v0.4.0. Managed-asset maintenance uses
  `atomy-toolkit cascade sync`.
- The Toolkit does not auto-merge, write a protected/default branch, or deploy
  a production endpoint.
- Cloud telemetry is not included. Toolkit telemetry is local, opt-in, and
  network-free.
- A future central service for batching embeddings from user-provided
  Memtemple records is a separate project. Railway or AWS hosting, and a
  possible cascade patch/update service, are future design and validation work;
  they are not delivered or operated by v0.4.0.

## Basic commands

```bash
atomy-toolkit --version
atomy-toolkit doctor
atomy-toolkit install ./my-project
atomy-toolkit memtemple --help
atomy-toolkit graph --help
atomy-toolkit afk --help
```

## Version terminology

GitHub tags such as `v0.4.0` are public Toolkit product releases. The historical
`1.0.0` value found in cascade metadata belongs to a separate internal asset
version lineage; it is not a public `v1.0.0` Toolkit release. This wheel carries
cascade master metadata `1.1.3`.

## License, notices, and privacy

Atomy Toolkit v0.4.0 is distributed under the [MIT License](LICENSE).
[NOTICE](NOTICE) identifies adapted engineering-discipline material, and
[Graph Report third-party notices](THIRD_PARTY_NOTICES.md) list its runtime
and development package records.

The release repository does not contain the private source tree. Clean-slate
packaging excludes source history, credentials, local memory, session/log
state, backups, and in-flight project documents.
