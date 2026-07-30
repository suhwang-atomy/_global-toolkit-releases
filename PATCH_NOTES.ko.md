# Atomy Toolkit v0.4.0 — 패치 노트

[English](PATCH_NOTES.md) | 한국어

- **상태:** 발행
- **릴리스 날짜:** 2026-07-30
- **비교 기준:** 공개 `v0.3.1` (2026-06-15)
- **source commit:** `59a3f49dee8977edb70ff8a2f3976db9e1633d99`

이 저장소에는 공개 Toolkit `v1.0.0` 릴리스가 없습니다. 과거 `1.0.0` 값은 공개
package 버전이 아니라 cascade metadata 버전입니다. 이 문서는 실제 이전 공개 버전인
v0.3.1과 v0.4.0을 비교합니다.

## 성숙도 표기

- **검증 완료:** 구현과 정의된 로컬 또는 통합 검증을 통과했습니다.
- **Preview:** 구현과 로컬 계약 검증은 통과했지만 명시된 live E2E 또는 운영 검증이
  남아 있습니다.
- **Experimental:** 첫 실제 환경 실행이나 핵심 동작 가정이 아직 검증되지 않았습니다.
- **Future:** v0.4.0에서 제공하지 않습니다.

## v0.3.1 이후 검증 완료 변경

### 안전한 cascade와 기존 프로젝트 유지보수

- `cascade sync`가 정규화된 origin hash를 사용해 Toolkit 기본 파일과 사용자 수정
  파일을 구분합니다.
- 적용 전 plan, 쓰기 직전 재검증, 원자 쓰기, 명시적 skip 사유와 의도적인 `--force`
  탈출구를 추가했습니다.
- Toolkit source 저장소가 cascade로 자기 자신을 덮어쓰는 실행을 차단했습니다.
- 보호된 `/new --upgrade`를 추가했습니다. read-only 진단, 관리 파일 inventory,
  byte backup, transaction rollback과 충돌 거부를 수행합니다. 사용자 코드, 일반 문서,
  memory, `.env`, Git metadata는 대상에서 제외합니다.
- hash가 확인된 Toolkit 기본 파일만 downstream 설치에서 제거할 수 있는 retirement
  record를 추가했습니다.

3-way merge 시스템은 아닙니다. 완료된 cascade 작업의 자동 rollback과 손상된 metadata
자동 복구는 제공하지 않습니다.

### Review, handoff와 worktree 워크플로

- `/review`가 사전 권한과 구현 후 품질 검토를 분리하고 diff, Goal, 수용 기준, 검증
  증거, 검토한 commit과 verdict를 하나의 change-set identity로 봉인합니다.
- 동일한 commit에 대한 review가 통과한 뒤에만 plan 완료 처리를 적용합니다.
- worktree-aware `/handoff`는 child worktree에서 공유 context를 직접 변경하는 대신 PR
  인계 기록을 생성합니다.
- carry-forward 회전은 명시적으로 활성 상태인 작업을 보존하고 완료 항목을 정리하며,
  불명확한 legacy 상태는 삭제하지 않고 경고합니다.
- `/audit`는 설정된 session 간격 또는 Phase 전환 때 알리지만 감사를 자동 실행하거나
  handoff를 차단하지 않습니다.
- workflow command가 로컬 opt-in 시작·결과 telemetry를 공통으로 사용합니다. 인자,
  prompt, 경로, 프로젝트명, branch명과 오류 본문은 저장하지 않습니다.

### Project Intelligence Graph와 Graph Report

- Graphify를 사용할 수 없을 때 Python AST로 강등하는 결정적 code-index
  build/status/find/impact 표면을 추가했습니다.
- 설정된 main workspace의 handoff는 stale한 memory/code index만 정해진 시간 안에
  현재 process에서 갱신합니다.
- 저장소 상대 파일 근거와 실제 symbol로 코드와 결정을 연결합니다. 저신뢰 후보와 동률
  후보는 연결하지 않습니다.
- scorecard, narrative, structure map, evidence appendix와 approval-based judge 화면이
  포함된 독립 실행형 offline Graph Report를 추가했습니다.
- Playwright `1.62.0`을 Graph Report의 직접 development dependency로
  고정했습니다. Ubuntu CI는 Chromium 브라우저 검사를 실행하며 Playwright는 runtime
  wheel에 포함되지 않습니다.
- Graph Report에서 설치된 MPL dependency 경로를 제거했습니다.
- 생성된 third-party notice는 runtime-bundled package record 35개를 정확히 포함합니다.
  라이선스는 MIT, ISC 또는 BSD-3-Clause이며 설치된 MPL 라이선스 package record는
  `0`개입니다.
- 같은 notice를 report template 옆에 포함하고 생성한 standalone report에도
  삽입합니다.

Graph Report는 로컬 artifact generator이며 hosted service가 아닙니다.

### Memory와 패키징 정리

- `/memory` slash command를 폐기했습니다. 공식 인터페이스는
  `atomy-toolkit memtemple`입니다.
- legacy Mempalace librarian/bootstrap module과 과거 embedding shim을 제거했습니다.
- backend-neutral core를 유지하고 local ChromaDB 지원을 필수 dependency가 아닌
  optional extra로 분리했습니다.
- clean wheel, sdist, environment에서 builtin Memtemple plugin manifest와
  extractor-to-drawer 동작을 검증합니다.
- clean-slate staging과 leak guard를 확장해 local Graph data, runtime state,
  자격증명, source history, 사용자 memory와 진행 중인 프로젝트 문서가 공개
  artifact에 들어가지 않게 했습니다.

### 로컬 governance primitive

- 결정적 검사, 제한된 waiver, hook/context mode와 비차단 로컬 proposal을 지원하는
  strict offline `.atomy/rulepack/` loader를 추가했습니다.
- opt-in 사용 기록, exact duplicate 검사, 후보를 실행하지 않는 정적 검사,
  `PASS`/`QUARANTINE`/`REJECT`, append-only provenance, snapshot과 transaction
  rollback을 포함한 보수적 skill lifecycle/intake primitive를 추가했습니다.
- command telemetry lifecycle과 결정적 audit reminder를 통일했습니다.

Rulepack과 skill API는 자동 merge, 자동 승격 또는 설치 skill 자동 이동을 수행하지
않습니다.

### 공개 패키징과 compliance

- 프로젝트를 MIT License로 선언하고 [LICENSE](LICENSE)를 wheel과 공개 릴리스
  저장소에 포함했습니다.
- adapted material attribution을 [NOTICE](NOTICE)에 포함했습니다.
- 생성된 [Graph Report third-party notices](THIRD_PARTY_NOTICES.md)를 포함했습니다.
- 원격 `uv` installer 자동 실행을 제거하고 실패 폐쇄형 prerequisite로 바꿨습니다.
  Python 3.12 이상을 사용하거나 `uv`를 별도로 먼저 설치해야 합니다.
- 고정 bootstrap은 설치 전에 wheel SHA256을 확인하며 항상 격리된 virtual
  environment에 설치합니다.
- v0.4.0 GitHub Release의 공식 asset은 정확히 wheel, `SHA256.txt`,
  `install-cli.sh`, `install-cli.ps1` 4개입니다.

## Preview

### Knowledge Fabric 수집과 federation

- opt-in·embedding-free memory/session manifest, actor별 증분 ledger, tombstone,
  spool intent, bounded transport와 `kf push|flush|status`를 추가했습니다.
- 로컬 loopback ingest/backfill/apply 전체 경로를 검증했습니다.
- 암호화 tunnel을 사용한 임시 기기간 왕복을 검증했습니다.

기기간 시험에 사용한 DGX는 당시 이용할 수 있었던 다른 PC였습니다. 운영 서버가 아니며
production topology의 일부가 아닙니다.

향후 사용자가 제공한 Memtemple 기록을 받아 embedding을 중앙에서 일괄 처리하는
서비스를 검토할 수 있습니다. Railway 또는 AWS hosting과 cascade patch/update service
가능성은 별도의 미래 설계·검증 과제입니다. v0.4.0은 이런 서비스를 배포하거나 운영하지
않습니다.

### Rulepack 협업 파일럿

- Codex worker와 Claude worker가 격리 worktree에서 같은 합성 계약을 구현했습니다.
- 두 결과 모두 같은 rulepack 입력에 대한 표적 검증을 통과했습니다.

파일럿은 로컬에서만 진행했습니다. 원격 협업, 다중 사용자 rollout과 운영 강제는
검증하지 않았습니다.

### Absence Batch와 Research Relay 실험

- draft-PR-only publish 계약과 격리 target을 구현했습니다.
- 로컬 결정적 테스트와 runtime packaging은 완료했습니다.

최초 외부 draft-PR live E2E와 Research Relay 예약 실행은 남아 있습니다. 이 실험들은
지원되는 기본 설치 flow에 포함되지 않습니다.

## Experimental

### `/delegate` 감독형 야간 자동화

구현된 항목:

- 사전에 봉인하는 단일 행동표
- 동적 host capability 검사
- 격리 worktree와 non-default branch
- controller-only run key, 자격증명, read와 copy
- network와 자격증명을 차단한 worker sandbox
- signed evidence와 action-item별 실패 격리
- 아침 `GO`/`NO-GO`; `NO-GO`의 원격 효과는 0

의도한 host는 Toolkit이 설치되고 capability 검사를 통과한 장치입니다. 예를 들어
퇴근할 때 켜 둔 workstation을 사용할 수 있으며 운영 서버 기능이 아닙니다. 첫 실제
full-night 실행과 다음 날 검수는 남아 있습니다.

### Adapter와 skill-lifecycle 제약

- Claude Code와 Codex는 깊은 verified adapter를 갖고 있습니다.
- Cursor와 Claude Desktop MCP 설정 경로는 정의된 검증을 완료했습니다.
- Antigravity는 부분 dogfood 증거가 있지만 workflow routing의 추가 검증이 필요합니다.
- Cowork는 capability profile이 있지만 live smoke를 완료하지 않았습니다.
- Skill lifecycle API는 fixture에서 검증했지만 실제 설치 skill 이동·활성화,
  downstream 공유와 사용자 memory 변경은 실행하지 않았습니다. 자동 이동은 꺼져
  있습니다.

## Breaking 및 migration 안내

- `/memory ...` 대신 `atomy-toolkit memtemple ...`을 사용하세요.
- 폐기된 Mempalace librarian module과 legacy embedding shim을 import하지 마세요.
- 로컬 embedding backend가 필요한 경우에만 optional local-embedding extra를
  설치하세요.
- `cascade sync`는 사용자 수정 Toolkit 파일을 기본적으로 보존합니다. 모든 파일이
  바뀌었다고 가정하지 말고 skip report를 확인하세요.
- 공개 bootstrap을 실행하기 전에 Python 3.12 이상 또는 `uv`를 설치하세요.
  bootstrap은 더 이상 `uv`를 자동 설치하지 않습니다.

## v0.4.0에서 동작하지 않는 기능

- `atomy-toolkit update`는 package를 다운로드·적용하지 않으며 `update rollback`도
  package를 복원하지 않습니다. 관리 asset 유지보수에는
  `atomy-toolkit cascade sync`를 사용합니다.
- P5 `/transfer`, P6 skill promotion ladder, 운영 embedding hub, 자동 merge,
  보호/default branch 쓰기와 production endpoint 배포는 제공하지 않습니다.

## 릴리스 식별 정보

| 항목 | 값 |
|---|---|
| Source commit | `59a3f49dee8977edb70ff8a2f3976db9e1633d99` |
| Cascade master metadata | `1.1.3` |
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` SHA256 | `13743ccc648631298c9a87449fef30134cb6036f64dfde456a997d4eea694834` |
| `SHA256.txt` SHA256 | `536e23217ab5216874277b9bc5a7f787065786645a4aacf50cfbf8b13ad02375` |
| `install-cli.sh` SHA256 | `1c705d7cc4c9337ff05e7ea9335980cd745fb72f3f149b5c20023f6f826b33ae` |
| `install-cli.ps1` SHA256 | `dd9af81d6f4705d765d461798cbe14b16ed9af84da4cb9a1712a2d9572657d34` |

릴리스 검증은 위 source commit과 공개 asset 4개에 적용됩니다. 독립 다운로드 검증
절차는 [공개 설치 가이드](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md)를 참고하세요.
