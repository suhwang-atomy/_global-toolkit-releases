# Next Atomy Toolkit Release — Patch Notes

English | [한국어](PATCH_NOTES.ko.md)

- **Status:** Unreleased candidate
- **Comparison baseline:** Public `v0.3.1` (2026-06-15)
- **Candidate source snapshot:** 2026-07-30
- **Candidate source commit:** `e2287f4125c8fdd620fa088299a7616499d92928`

There is no public Toolkit `v1.0.0` release in this repository. The historical
`1.0.0` value belongs to cascade metadata, not the public package version.
These notes therefore compare the candidate with the actual latest public
release, `v0.3.1`.

## Maturity labels

- **Verified:** implementation and its defined local/integration verification
  passed.
- **Preview:** implementation and local contracts passed, but a named live E2E
  or production validation is still pending.
- **Experimental:** the first real-environment run or a core operating
  assumption remains unverified.
- **Future:** not available in this candidate.

## Verified changes since v0.3.1

### Safer cascade and existing-project maintenance

- Added normalized origin hashes so `cascade sync` can distinguish untouched
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
cascade operation and damaged-metadata repair are not provided.

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
- `/audit` can remind on a configurable session interval or phase transition
  without automatically running an audit or blocking handoff.
- Six workflow commands share local, opt-in start/result telemetry. Arguments,
  prompts, paths, project names, branch names, and error bodies are not stored.

### Project Intelligence Graph and Graph Report

- Added deterministic code index build/status/find/impact surfaces with a
  Python AST fallback when Graphify is unavailable.
- Configured main workspaces refresh only stale memory/code indexes during
  handoff, in-process and within fixed time budgets.
- Added code-to-decision links based on repository-relative file evidence and
  real symbols; low-confidence or tied candidates remain unlinked.
- Added a self-contained offline Graph Report with scorecard, narrative,
  structure map, and evidence appendix.
- Added an approval-based judge view that fails closed on unapproved values.
- The final protected-data dogfood seal passed with leak count `0`; its approved
  decision link and scorecard metrics matched the sealed expectations.
- Removed the Graph Report MPL-2.0 dependency path; the final lockfile had zero
  MPL-2.0 packages and `npm audit` reported zero findings.

Graph Report is a local artifact generator, not a hosted service.

### Memory and packaging cleanup

- Retired the `/memory` slash command. The supported interface is now
  `atomy-toolkit memtemple`.
- Removed legacy Mempalace librarian/bootstrap modules and the obsolete
  embedding shim.
- Kept backend-neutral core behavior; local ChromaDB support is an optional
  extra rather than a required dependency.
- Hardened wheel/sdist/clean-venv checks for the five built-in Memtemple plugin
  manifests and extractor-to-drawer behavior.
- Extended clean-slate staging and leak guards so local Graph, runtime state,
  credentials, source history, and in-flight memory cannot enter public
  artifacts.

### Local governance primitives

- Added a strict offline `.atomy/rulepack/` loader with deterministic checks,
  bounded waivers, hook/context modes, and non-blocking local proposals.
- Added conservative skill lifecycle and intake primitives: opt-in usage
  records, exact duplicate checks, non-executing static scans,
  `PASS`/`QUARANTINE`/`REJECT`, append-only provenance, snapshots, and
  transaction rollback.
- Added command telemetry lifecycle consistency and deterministic audit
  reminders.

The rulepack and skill APIs do not auto-merge, auto-promote, or automatically
move installed skills.

## Preview

### Knowledge Fabric collection and federation

- Added opt-in, embedding-free memory/session manifests, per-actor incremental
  ledgers, tombstones, spool intents, bounded transport, and
  `kf push|flush|status`.
- Verified a complete local loopback ingest/backfill/apply path.
- Verified a temporary encrypted-tunnel cross-device round trip using a remote
  test resource.

The remote device was not a production server. No supported central hub,
custody policy, production deployment, or cascade-update service exists yet.

### Rulepack collaboration pilot

- A Codex worker and a Claude worker implemented the same synthetic contract in
  isolated Orca worktrees.
- Both outputs passed their focused tests and the same rulepack input.

The pilot was local only. No remote push, PR workflow, multi-user rollout, or
production enforcement was validated.

### Absence Batch and Research Relay labs

- Draft-PR-only publishing contracts and isolated targets are implemented.
- Local deterministic tests and runtime packaging are complete.

The first live external draft-PR E2E and scheduled Research Relay run remain
pending. These labs are not part of the supported default installation
workflow.

## Experimental

### `/delegate` supervised overnight automation

Implemented:

- one sealed pre-run action table;
- dynamic host capability checks;
- isolated worktree and non-default branch;
- controller-only run key, credentials, reads, and copies;
- a network- and credential-denied worker sandbox;
- signed evidence and exact action-to-item failure isolation;
- morning `GO`/`NO-GO`, where `NO-GO` has no remote effect.

The first real full-chain night and next-morning review have not run. Until that
evidence exists, use this only on a capability-checked Toolkit device with an
isolated branch. It is not an operating-server feature.

### Adapter limits

- Claude Code and Codex have deep verified adapters.
- Cursor and the Claude Desktop MCP configuration path have completed their
  defined verification.
- Antigravity has a three-layer adapter and partial dogfood evidence, but its
  workflow-routing assumptions need a new revision.
- Cowork retains a capability profile without a completed live smoke.

### Skill lifecycle and intake mutation

The APIs are implemented and fixture-tested, but real installed-skill moves,
activation, downstream sharing, and user-memory mutation have not been run.
Automatic movement remains off.

## Breaking and migration notes

- Replace `/memory ...` with `atomy-toolkit memtemple ...`.
- Do not import retired Mempalace librarian modules or the legacy embedding
  shim.
- Install the optional local embedding extra only when a local embedding
  backend is required.
- Existing user-edited Toolkit files are preserved by default during
  `cascade sync`; review skip reports instead of assuming every file changed.

## Not operational in this candidate

- `atomy-toolkit update` does not yet download and apply a package, and
  `update rollback` does not restore one. Those commands currently expose
  discovery/confirmation scaffolding only.
- The candidate's managed-asset path is `atomy-toolkit cascade sync`, not
  generic self-update. Its origin-hash protections are not in public `v0.3.1`.
- P5 `/transfer`, the P6 skill promotion ladder, a production embedding hub,
  automatic merge, protected/default-branch writes, and production endpoint
  deployment are not provided.

## Candidate verification snapshot

- Full Python suite: `3,223 passed`, `16 skipped`, `1 xfailed`
- AFK and contract suite: `451 passed`, `1 xfailed`
- Changed Python source: Ruff and mypy clean
- Cascade-focused bundle: `97 passed`
- Graph seal: candidate source commit, tracked-clean input, owner artifact
  deleted, judge leak count `0`

These results describe the source candidate. A release is complete only after a
new version, clean wheel, checksum, command installers, isolated install smoke,
and GitHub Release are published and verified.
