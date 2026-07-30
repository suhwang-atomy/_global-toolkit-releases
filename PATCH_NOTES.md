# Atomy Toolkit v0.4.0 — Patch Notes

English | [한국어](PATCH_NOTES.ko.md)

- **Status:** Released
- **Release date:** 2026-07-30
- **Comparison baseline:** Public `v0.3.1` (2026-06-15)
- **Source commit:** `f321cc47045bec5c0b08f05163fec2e44bc408f4`

There is no public Toolkit `v1.0.0` release in this repository. The historical
`1.0.0` value belongs to cascade metadata, not the public package version.
These notes compare v0.4.0 with the actual previous public release, v0.3.1.

## Maturity labels

- **Verified:** implementation and its defined local or integration
  verification passed.
- **Preview:** implementation and local contracts passed, but a named live E2E
  or production validation is still pending.
- **Experimental:** the first real-environment run or a core operating
  assumption remains unverified.
- **Future:** not provided by v0.4.0.

## Verified changes since v0.3.1

### Safer cascade and existing-project maintenance

- Added normalized origin hashes so `cascade sync` distinguishes untouched
  Toolkit defaults from user-edited files.
- Added plan-before-apply, immediate revalidation, atomic writes, explicit skip
  reasons, and a deliberate `--force` escape hatch.
- Blocked cascade synchronization from overwriting the Toolkit source
  repository itself.
- Added guarded `/new --upgrade`: read-only diagnosis, managed-file inventory,
  byte backup, transactional rollback, and conflict refusal. User code,
  ordinary documents, memory, `.env`, and Git metadata stay out of scope.
- Added hash-gated retirement records so only known, unmodified Toolkit
  defaults can be removed from downstream installations.

This is not a three-way merge system. Automatic rollback after a completed
cascade operation and automatic repair of damaged metadata are not provided.

### Review, handoff, and worktree workflows

- `/review` now separates prior authority from post-implementation quality
  review and seals the diff, goal, acceptance criteria, verification evidence,
  reviewed commit, and verdict under one change-set identity.
- Plan completion is applied only after review passes for the same committed
  change.
- Worktree-aware `/handoff` creates a PR handoff record instead of mutating
  shared project context from a child worktree.
- Carry-forward rotation preserves explicitly active work, retires completed
  entries, and keeps ambiguous legacy state with a warning.
- `/audit` can remind on a configured session interval or phase transition
  without automatically running an audit or blocking handoff.
- Workflow commands share local, opt-in start/result telemetry. Arguments,
  prompts, paths, project names, branch names, and error bodies are not stored.

### Project Intelligence Graph and Graph Report

- Added deterministic code-index build, status, find, and impact surfaces with
  a Python AST fallback when Graphify is unavailable.
- Configured main workspaces refresh only stale memory/code indexes during
  handoff, in-process and within fixed time budgets.
- Added code-to-decision links based on repository-relative file evidence and
  real symbols; low-confidence or tied candidates remain unlinked.
- Added a self-contained offline Graph Report with scorecard, narrative,
  structure map, evidence appendix, and an approval-based judge view.
- Pinned Playwright `1.62.0` as a direct Graph Report development dependency.
  Ubuntu CI runs Chromium browser checks; Playwright is excluded from the
  runtime wheel.
- Removed the installed MPL dependency path from Graph Report.
- Generated third-party notices cover exactly 35 runtime-bundled package
  records. Their licenses are MIT, ISC, or BSD-3-Clause; installed
  MPL-licensed package records are `0`.
- The same notice set is shipped beside the report template and embedded into
  generated standalone reports.

Graph Report is a local artifact generator, not a hosted service.

### Memory and packaging cleanup

- Retired the `/memory` slash command. The supported interface is now
  `atomy-toolkit memtemple`.
- Removed legacy Mempalace librarian/bootstrap modules and the obsolete
  embedding shim.
- Kept backend-neutral core behavior; local ChromaDB support is an optional
  extra rather than a required dependency.
- Hardened wheel, sdist, and clean-environment checks for built-in Memtemple
  plugin manifests and extractor-to-drawer behavior.
- Extended clean-slate staging and leak guards so local Graph data, runtime
  state, credentials, source history, user memory, and in-flight project
  documents cannot enter public artifacts.

### Local governance primitives

- Added a strict offline `.atomy/rulepack/` loader with deterministic checks,
  bounded waivers, hook/context modes, and non-blocking local proposals.
- Added conservative skill lifecycle and intake primitives: opt-in usage
  records, exact duplicate checks, non-executing static scans,
  `PASS`/`QUARANTINE`/`REJECT`, append-only provenance, snapshots, and
  transaction rollback.
- Added consistent command-telemetry lifecycle handling and deterministic audit
  reminders.

The rulepack and skill APIs do not auto-merge, auto-promote, or automatically
move installed skills.

### Public packaging and compliance

- Declared the project license as MIT and included [LICENSE](LICENSE) in the
  wheel and public release repository.
- Included adapted-material attribution in [NOTICE](NOTICE).
- Included the generated
  [Graph Report third-party notices](THIRD_PARTY_NOTICES.md).
- Replaced automatic remote `uv` installer execution with a fail-closed
  prerequisite: use Python 3.12+ or install `uv` separately first.
- The pinned bootstrap verifies the wheel SHA256 before installation and always
  installs into an isolated virtual environment.
- The supported v0.4.0 GitHub Release contains exactly four assets: the wheel,
  `SHA256.txt`, `install-cli.sh`, and `install-cli.ps1`.

## Preview

### Knowledge Fabric collection and federation

- Added opt-in, embedding-free memory/session manifests, per-actor incremental
  ledgers, tombstones, spool intents, bounded transport, and
  `kf push|flush|status`.
- Verified a complete local loopback ingest/backfill/apply path.
- Verified a temporary encrypted-tunnel cross-device round trip.

The DGX in the cross-device test was simply another available PC. It was not
an operating server and is not part of a production topology.

A future service could accept user-provided Memtemple records and batch their
embedding work centrally. Railway or AWS hosting and a possible cascade
patch/update service are separate future design and validation tasks. v0.4.0
does not deploy or operate those services.

### Rulepack collaboration pilot

- A Codex worker and a Claude worker implemented the same synthetic contract in
  isolated worktrees.
- Both outputs passed their focused tests against the same rulepack input.

The pilot was local only. Remote collaboration, multi-user rollout, and
production enforcement were not validated.

### Absence Batch and Research Relay labs

- Draft-PR-only publishing contracts and isolated targets are implemented.
- Local deterministic tests and runtime packaging are complete.

The first live external draft-PR E2E and scheduled Research Relay run remain
pending. These labs are not part of the supported default installation flow.

## Experimental

### `/delegate` supervised overnight automation

Implemented:

- one sealed pre-run action table;
- dynamic host capability checks;
- an isolated worktree and non-default branch;
- controller-only run key, credentials, reads, and copies;
- a network- and credential-denied worker sandbox;
- signed evidence and exact action-to-item failure isolation; and
- morning `GO`/`NO-GO`, where `NO-GO` has no remote effect.

The intended host is a capability-checked device with the Toolkit installed,
such as a workstation left on overnight. It is not an operating-server feature.
The first full real overnight run and next-morning review are complete.

### Adapter and skill-lifecycle limits

- Claude Code and Codex have deep verified adapters.
- Cursor and the Claude Desktop MCP configuration path completed their defined
  verification.
- Antigravity retains partial dogfood evidence but needs further
  workflow-routing validation.
- Cowork retains a capability profile without a completed live smoke.
- Skill lifecycle APIs are fixture-tested, but real installed-skill movement,
  activation, downstream sharing, and user-memory mutation have not run.
  Automatic movement remains off.

## Breaking and migration notes

- Replace `/memory ...` with `atomy-toolkit memtemple ...`.
- Do not import retired Mempalace librarian modules or the legacy embedding
  shim.
- Install the optional local-embedding extra only when a local embedding
  backend is required.
- Existing user-edited Toolkit files are preserved by default during
  `cascade sync`; review skip reports instead of assuming every file changed.
- Ensure Python 3.12+ or `uv` is installed before running the public
  bootstrap. The bootstrap no longer installs `uv` automatically.

## Not operational in v0.4.0

- `atomy-toolkit update` does not download and apply a package, and
  `update rollback` does not restore one. Managed-asset maintenance uses
  `atomy-toolkit cascade sync`.
- P5 `/transfer`, the P6 skill-promotion ladder, a production embedding hub,
  automatic merge, protected/default-branch writes, and production endpoint
  deployment are not provided.

## Release identity

| Item | Value |
|---|---|
| Source commit | `f321cc47045bec5c0b08f05163fec2e44bc408f4` |
| Cascade master metadata | `1.1.3` |
| Reproducible wheel epoch | `SOURCE_DATE_EPOCH=1785391413` |
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` SHA256 | `bd90615f04c647a0d3e004ea75e65bb18bad3467a335316b0d9883c079c2043a` |
| `SHA256.txt` SHA256 | `563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d` |
| `install-cli.sh` SHA256 | `c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc` |
| `install-cli.ps1` SHA256 | `0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804` |

Release verification covers the exact source commit and these four public
assets. See the [public install guide](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md)
for independent download verification.
