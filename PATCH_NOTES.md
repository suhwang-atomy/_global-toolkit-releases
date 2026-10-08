# Atomy Toolkit 0.5.0 — 조직 업무와 기능별 기록

같은 기능의 개발·피드백·추가 작업과 결정 이유를 시간순으로 연결하고, 근거를 펼쳐 보며 AI에 후속 질문을 이어갈 수 있습니다.

- 기능별 이력과 질문 화면, 코드 근거 설명, 바선생 자기 점검을 연결했습니다. 좁은 화면에서도 긴 파일 이름이 줄바꿈됩니다.
- 보고서·자료·개발 작업의 보관 위치와 연결을 정리하고, 프로젝트별 역할·업무 배정·인계·복귀·도움 요청을 지원합니다.
- 공통 기본 규칙을 설치판에 넣었습니다. 프로젝트 추가 조건은 덧붙이며 기존 파일은 보존합니다.
- 규칙 서버는 기본 꺼짐입니다. 준비된 업데이트에서 전환할 수 있고 직접 꺼둔 선택은 유지됩니다.
- 심사 도구 제출 자료 준비, 결과물 재사용, 동의에 따른 중앙 진단과 업무 효과 기록 도구를 추가했습니다. 실제 수신처·운영 서버는 별도 설정해야 합니다.
- Mac·Linux·Windows 설치 파일과 안내를 같은 배포 목록에서 생성합니다. 기존 사용자 설정을 보존하고 설치 후 도구 연결을 확인합니다.

## 설치

[Mac을 포함한 설치 안내](https://github.com/suhwang-atomy/_global-toolkit-releases/blob/main/INSTALL.md)를 따라 설치하세요. Python 3.12 이상 또는 미리 설치한 uv가 필요합니다. 설치한 뒤 기존 AI 앱을 완전히 종료하고 다시 열어 주세요.

## 확인 범위

이번 배포 후보의 전체 자동 검사 6,374개가 통과했고 실제 실패는 없었습니다. 별도 환경이 필요한 24개와 기존 미구현 항목 1개는 제외했습니다. 관련 기능은 별도 설치본에서 50개 검사를 통과했고, 실제 프로젝트의 기능 질문·시간순 화면·출처 펼치기·좁은 화면 동작을 확인했습니다.

배포 파일 13개의 내용 지문을 대조했으며 설치 파일의 개인 자료 검사 결과는 0건입니다. 이 기기에서 수행한 검사이며 Mac 실기기 설치 완료를 의미하지 않습니다.

공식 사내 규정·실제 조직 서버·여러 사람의 기기 간 운영은 아직 확인되지 않았습니다. 규칙 서버와 중앙 진단 수집을 이번 게시로 켜지 않습니다. Mac·Windows 실기기 설치와 열린 앱의 실제 사용은 별도 확인 대상입니다.

이 공개 저장소에는 설치 파일과 공개 안내만 제공합니다. 내부 개발 이력·보고서·개인 기록은 포함하지 않습니다.

---

# Atomy Toolkit 0.4.9

긴 대화 뒤쪽의 내용도 검색하고, 원문이 늘어도 기존 요약과 결정을 보존합니다. 인계 도중 끊겼을 때 이미 끝난 일을 반복하지 않고 남은 처리 기록을 확인할 수 있습니다.

- 검색어와 관계없는 자료를 결과 수에 맞춰 끼워 넣지 않습니다. 다른 장치의 원문이 안 보이면 현재 장치에서 찾지 못했다고 표시합니다.
- 인계 안내를 간결하게 정리했습니다. 다음 작업 저장이나 필수 확인이 빠지면 전체 완료로 표시하지 않습니다.
- 사용량은 새 입력·재사용 입력·출력으로 나눕니다. 기록된 사용량을 실제 청구액으로 표시하지 않습니다.
- 공개 설치 안내와 설치 파일을 같은 배포 목록에서 생성합니다. 기존 설정을 보존하고 실제 도구 연결을 확인합니다.

전체 자동 검사 5,217개와 추가 관련 검사를 통과했습니다. Linux의 새 설치·재설치에서 Claude Code·Codex 연결 도구 14개와 읽기 호출, 요약 저장·긴 대화 검색을 확인했습니다. Windows·macOS 실기기와 열린 앱의 재시작 화면은 이번에 확인하지 않았습니다.

작은 합성 예제 비교에서 두 모델 모두 인계 확인 13항목을 충족했습니다. 실제 장기 작업 속도나 청구 비용의 절감률을 보장하지 않습니다.

외부 규칙 검사 서비스는 인증 오류로 확인하지 못했습니다. 공개 파일의 개인 자료 검사와 저장소의 배포 규칙 대조는 수행했으며, 외부 규정 검사 통과를 주장하지 않습니다.

[설치 안내](https://github.com/suhwang-atomy/_global-toolkit-releases/blob/main/INSTALL.md)

---

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
The first full real overnight run and next-morning review are complete. Its
timing and back-stop settings are still provisional and pending replacement
with measured data, so the feature stays under Preview rather than Verified.

## Experimental

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
