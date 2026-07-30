# Atomy Toolkit Releases

English | [한국어](README.ko.md)

Public, clean-slate release artifacts for Atomy Toolkit, a local-first workflow
kit for agentic software development across coding tools.

The source repository remains private. This repository contains only public
installers, checksums, and release documentation.

> **Release status**
>
> - Latest published release: [v0.3.1](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.3.1)
> - Next release: **unreleased candidate**
> - Detailed changes: [English patch notes](PATCH_NOTES.md) ·
>   [한국어 패치 노트](PATCH_NOTES.ko.md)
>
> The commands below still install `v0.3.1` until a new wheel and checksum are
> published. Updating this README alone does not distribute the unreleased
> candidate.

## Install the current v0.3.1 release

### Pinned and checksum-verified bootstrap (recommended)

<!-- markdownlint-disable MD013 -->

Linux:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.3.1/install-cli.sh
echo "58999d57853882be7f7fa4c2f457f59ba0798e23e9b25d0ec380a56ea3b3ff47  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

macOS:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.3.1/install-cli.sh
echo "58999d57853882be7f7fa4c2f457f59ba0798e23e9b25d0ec380a56ea3b3ff47  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

Windows 11 PowerShell:

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.3.1/install-cli.ps1 -OutFile install-cli.ps1
$expected = "79448b73c543d96cd5e374fd5c32f22929083bd57d6dfed428d05a0d5b49db7c"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

<!-- markdownlint-enable MD013 -->

This verifies the pinned bootstrap script before executing it. The bootstrap
then:

1. finds or provisions Python 3.12 with `uv`;
2. downloads the pinned `atomy_toolkit_lib-0.3.1-py3-none-any.whl`;
3. verifies its published SHA256 checksum;
4. installs it into an isolated virtual environment; and
5. runs `atomy-toolkit self-install`.

It does not install into the system Python environment. If Python 3.12 is
missing, the bootstrap downloads and executes the third-party `uv` installer.

### Convenience channel

The familiar `releases/latest/download/install-cli.*` one-liner is shorter but
less reproducible: it executes the latest unsigned bootstrap directly, so only
the wheel—not that bootstrap script—is checksum-verified. Use the pinned flow
above when integrity and reproducibility matter.

## What the next candidate adds

The next candidate is intentionally split by maturity. “Implemented” does not
automatically mean “proven in a live or production environment.”

### Verified in the candidate

- **Safer project maintenance** — `cascade sync` preserves user-modified files
  using origin hashes, revalidates before writing, and reports every skipped
  path. `/new --upgrade` diagnoses first, backs up managed files, and rolls
  back a failed transaction.
- **Evidence-based workflows** — `/review` binds the diff, goal, acceptance
  criteria, verification evidence, reviewed commit, and plan bookkeeping.
  `/handoff` preserves active context and refreshes stale configured Graph
  indexes without blocking handoff on refresh failure.
- **Memtemple continuity** — the supported memory surface is
  `atomy-toolkit memtemple`; legacy Mempalace libraries and the old embedding
  shim have been retired.
- **Project Intelligence Graph** — deterministic code indexes, code-to-decision
  links, impact queries, and a self-contained Graph Report with an
  approval-based judge view.
- **Local controls** — opt-in, network-free command telemetry; deterministic
  audit reminders; guarded skill intake primitives; and offline project
  rulepack checks.
- **Verified adapter paths** — Claude Code, Codex, Cursor, and the Claude
  Desktop MCP configuration path completed their defined validation.
- **Release hygiene** — clean-slate packaging, secret/leak guards, reversible
  retirement of known Toolkit defaults, and an MPL-2.0-free Graph Report
  dependency tree.

### Preview

- **Rulepack collaboration** — a Codex/Claude two-worktree pilot completed
  locally, but remote collaboration and production rollout have not been
  validated.
- **Knowledge Fabric federation** — local loopback and temporary cross-device
  transfer were tested. There is no supported production hub yet; the remote
  device used in testing was only a temporary test resource.
- **Absence Batch and Research Relay** — isolated, draft-PR-only contracts are
  implemented. Their first live external E2E and scheduled run are pending.

### Experimental

- **`/delegate` overnight automation** — the signed action envelope, isolated
  worktree, worker sandbox, controller-only credentials, and morning
  `GO`/`NO-GO` flow are implemented and regression-tested. The first real
  full-night run is still pending.
- **Antigravity and Cowork adapters** — their installation and capability
  surfaces exist, but Antigravity needs a workflow-routing revision and Cowork
  has not completed a live smoke.
- **Skill lifecycle and intake mutation** — APIs are fixture-tested, but real
  installed-skill moves, activation, downstream sharing, and user-memory
  mutation have not run. Automatic movement remains off.

Preview and experimental features are not a promise of production support.
Automation that can create commits or remote effects must remain on isolated,
non-default branches and may require a supervised first run.

## Important limitations

- `atomy-toolkit update` and `update rollback` are not operational package
  replacement/restore paths in this candidate. They currently provide
  discovery and confirmation scaffolding only.
- The candidate's origin-hash-protected `cascade sync` is not present in the
  public `v0.3.1` wheel. Do not assume the current release has those
  protections.
- The Toolkit never auto-merges, writes a protected/default branch, or deploys
  a production endpoint as part of the preview automation.
- Cloud telemetry is not included. Toolkit telemetry is local, opt-in, and
  network-free.
- Native `v0.1.0` Windows/macOS artifacts are legacy unsigned test artifacts.
  The supported public channel from `v0.2.0` onward is the wheel plus the
  command installers above.

## Basic commands available in v0.3.1

```bash
atomy-toolkit --version
atomy-toolkit doctor
atomy-toolkit install ./my-project
atomy-toolkit memtemple --help
```

Candidate-only command and workflow surfaces are described in the patch notes.
They are not available from the public installer until new release assets are
published. In particular, `atomy-toolkit graph` is not in the public `v0.3.1`
wheel. That release already included an earlier `/delegate` workflow, but not
the candidate's sealed, supervised overnight execution.

## Version terminology

GitHub tags such as `v0.3.1` are public Toolkit product releases. The historical
`1.0.0` value found in cascade metadata belongs to a separate internal asset
version lineage; it is **not** a public `v1.0.0` Toolkit release.

## Integrity and privacy

- The recommended pinned path verifies the bootstrap script hash, and the
  bootstrap verifies the wheel against the published SHA256 file.
- The convenience one-liner does not verify the bootstrap script itself.
- Clean-slate packaging excludes source history, credentials, local memory,
  runtime state, and in-flight project documents.
- The release repository does not contain the private source tree.
- The `v0.3.1` wheel and command installers are unsigned. The pinned hashes
  above are the integrity control for the current public release.
