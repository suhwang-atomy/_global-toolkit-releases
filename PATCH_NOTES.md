# Atomy Toolkit 0.6.0 — 일의 모양에 맞춘 관리·가벼운 기록·안전장치·Windows 지원

0.5.0 이후 달라진 점입니다.

## 새 기능

- **`/new`가 일의 모양을 먼저 묻습니다.** 개발인지 문서 업무인지, 여러 문서·파일이 서로 얽혀 있는지 확인합니다.
  얽힌 일이면 **관계 사전**(어떤 값이 어느 문서·결과물에 쓰이는지 적은 표)을 만들고, 문서 업무 폴더에는 짧은 안내 파일을 따로 둡니다.
  기존 프로젝트의 안내 파일은 `atomy-toolkit dictionary guide-update`로 툴킷 칸만 갱신합니다.
- **관계 사전 확인 장치.** 사람이 확인한 칸은 함부로 고쳐지지 않게 보호합니다.
  승인 도장, 시험지 채점, 결과물(워드·파워포인트·엑셀) 글자 대조로 "고치기 전 값이 남아 있지 않은지" 확인합니다.
  문서 업무를 끝남으로 기록할 때 이 확인을 거치고, 문서 프로젝트에 개발 폴더를 붙일 수도 있습니다(`dictionary attach-dev`).
  쓸 때마다 대조하는 알림은 기본 꺼짐입니다(`atomy-toolkit dictionary mode`로 켬).
- **맥락 기록을 가볍게 유지합니다.** AI가 매번 읽는 `docs/context.md` 맨 위에 '지금 상태' 칸을 두고, 결정은 결정 원장으로 나눕니다.
  7,000자를 넘으면 `/handoff`가 정리를 돌립니다. 미결은 계획의 보류 칸이나 보관 기억으로, 지난 기록은 일지로 옮깁니다. 지우지 않습니다.
  옛 형식은 `atomy-toolkit context migrate`로 옮길 수 있습니다(미리 보기 → 적용, 되돌리기 기록표).
- **끝난 설계서·계획을 자동으로 보관합니다.** 근거와 함께 "끝남" 도장(`atomy-toolkit plandoc seal`)을 찍은 문서는 마감 때
  `docs/archive/`로 옮기고, 가리키던 링크를 고칩니다. 다른 열린 계획이 쓰는 설계서는 옮기지 않습니다.
- **되돌리기 어려운 행동 앞 승인 창과 보호 단계.** 대량 삭제, DB 구조 변경, 배포, main 가지에 바로 올리기, 외부 전송,
  출시 이름표 올리기 전에 묻습니다. 보호 단계(`off`·`default`·`strict`)는 이 컴퓨터의 기록으로 정합니다. 낮추기는 사람이 터미널에서
  화면의 숫자를 직접 입력해야만 됩니다. Claude 데스크톱 앱의 터미널 패널로 치는 명령도 봅니다.
- **대화 저장(서랍 v3).** 사람 말과 AI가 실제로 한 작업을 차례대로 남기고, 보조 에이전트의 대화도 저장합니다.
  `/handoff`는 창을 여러 개 열어 둬도 지금 대화를 정확히 골라 저장합니다(Codex 포함).

## 고친 점

- **Windows**
  - 한글 파일 읽기·쓰기와 한글 출력이 깨지던 문제를 고쳤습니다.
  - 줄바꿈이 CRLF로 바뀌어 기록 지문이 어긋나던 문제를 고쳤습니다.
  - 한국어 Windows의 PowerShell 5.1에서 설치 스크립트가 깨지던 문제를 고쳤습니다.
  - 백업 스크립트가 git 안내 출력에 멈추던 문제를 고쳤습니다.
  - 팀원이 기록한 결정·파일 근거가 Windows에서 받으면 '바뀜'으로 보이던 문제를 고쳤습니다(줄바꿈 차이는 같은 내용으로 봅니다).
  - 여러 작업이 같은 파일을 동시에 쓸 때 드물게 '저장소 밖 경로' 오류가 나던 문제를 고쳤습니다.
- `/handoff`의 대화 저장이 다시 묻지 않고 바로 됩니다(0.4.9·0.5.0에서 생긴 문제).
- `/handoff`가 checklist 기록을 자동으로 옮기지 않습니다. 최신 기록이 밀려나던 문제 때문이며, 이제 확인한 것만 옮깁니다.
- `/new`가 `src/`를 통째로 지우던 문제, 설치 직후 도메인 메모리·settings.json이 사라지던 문제를 고쳤습니다.
  옛 설치로 피해를 입은 프로젝트는 `atomy-toolkit doctor`가 찾아 알려 줍니다.
- `/undo` 복제본이 큰 폴더를 통째로 복사하지 않습니다. 한 벌 2GB·디스크 여유 5GB 기준이며, 최근 5벌을 보관합니다.
- Antigravity에서 툴킷 명령이 다시 보입니다(새 자리 `.agents/skills`).
- 기억 검색의 `--llm`이 기억 원문을 외부 AI로 보내지 않습니다. 이 기기 안의 AI만 씁니다.
- `/rpi`·`/handoff`의 반복 승인을 없앴습니다.
- AI에게 전달되지 않던 알림 훅 6개를 없앴습니다. 이미 깔린 곳도 `cascade sync`·재설치 때 정리됩니다.

## 알아 둘 것

- 이미 툴킷을 쓰던 프로젝트는 `atomy-toolkit cascade sync`로 새 판의 파일을 받습니다.
  보호 훅이 없다는 알림이 나와도 같은 명령으로 되살립니다.
- Windows ARM 기기에서는 ARM용 Python으로 설치되지 않습니다(보안 부품 `cryptography` 48의 ARM 판이 아직 없음).
  x64용 Python 3.12를 깔아 쓰면 설치됩니다.
- Windows에서 아주 깊은 폴더(경로 260자 초과)는 Windows의 '긴 경로 허용' 설정이 필요할 수 있습니다.

## 설치

[설치 안내](https://github.com/suhwang-atomy/_global-toolkit-releases/blob/main/INSTALL.md)를 따라 설치하세요(macOS·Linux·Windows x64). Python 3.12 이상 또는 미리 설치한 uv가 필요합니다. 설치한 뒤 기존 AI 앱을 완전히 종료하고 다시 열어 주세요. 이미 툴킷을 쓰던 프로젝트는 `atomy-toolkit cascade sync`로 새 판의 파일을 받습니다.

## 확인 범위

- Linux: 이 배포 후보와 같은 내용의 전체 자동 검사 8,045개가 통과했고 실패는 없었습니다. 별도 환경이 필요한 27개와 기존 미구현 항목 1개는 제외했습니다.
- Windows 11(ARM 기기에서 x64 Python 3.12): 최종 판에서 7,872개 통과. 실패 2개는 가상환경 안에서 설치 묶음을 다시 만들어 보는 시험의 환경 문제입니다(Linux에서는 통과). 개발자 모드가 꺼져 바로가기를 만들 수 없는 81개는 건너뛰었습니다.
- macOS(Apple 실리콘): Windows 대응 수정이 끝나기 전 판에서 8,028개 통과. 같은 설치 묶음 시험 2개가 실패했고, 병렬 실행 중 git·python이 비정상 종료한 8개는 다시 돌리면 모두 통과했습니다.
- 배포 파일 13개의 내용 지문을 대조했으며 설치 파일의 개인 자료 검사 결과는 0건입니다.

Windows·macOS 결과는 자동 검사 기준입니다. 실기기에 새로 설치해 AI 앱에서 쓰는 확인은 별도 대상입니다. 공식 사내 규정·실제 조직 서버·여러 사람의 기기 간 운영은 아직 확인되지 않았습니다.

이 공개 저장소에는 설치 파일과 공개 안내만 제공합니다. 내부 개발 이력·보고서·개인 기록은 포함하지 않습니다.

---

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
