# Atomy Toolkit 릴리스

[English](README.md) | 한국어

Atomy Toolkit의 공개 clean-slate 배포 저장소입니다. Atomy Toolkit은 여러 코딩
도구에서 에이전틱 소프트웨어 개발 흐름을 일관되게 사용할 수 있도록 구성한 로컬 우선
워크플로 툴킷입니다.

소스 저장소는 비공개입니다. 이 저장소에는 공개 설치 파일, 체크섬, 릴리스 문서만
포함됩니다.

> **릴리스 상태**
>
> - 현재 공개 최신 버전: [v0.3.1](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.3.1)
> - 다음 버전: **미발행 후보**
> - 상세 변경: [한국어 패치 노트](PATCH_NOTES.ko.md) ·
>   [English patch notes](PATCH_NOTES.md)
>
> 새 wheel과 체크섬을 발행하기 전까지 아래 명령은 계속 `v0.3.1`을 설치합니다.
> README만 변경해서는 미발행 후보가 사용자에게 배포되지 않습니다.

## 현재 공개 v0.3.1 설치

### 버전 고정 및 bootstrap 체크섬 검증 설치(권장)

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

이 경로는 버전을 고정한 bootstrap script를 실행 전에 검증합니다. 이후 bootstrap은
다음 순서로 동작합니다.

1. Python 3.12를 찾거나 `uv`로 준비합니다.
2. 고정된 `atomy_toolkit_lib-0.3.1-py3-none-any.whl`을 다운로드합니다.
3. 공개된 SHA256 체크섬을 검증합니다.
4. 격리된 가상환경에 설치합니다.
5. `atomy-toolkit self-install`을 실행합니다.

system Python에는 설치하지 않습니다. Python 3.12가 없으면 bootstrap이 제3자 `uv`
설치 script를 다운로드해 실행합니다.

### 편의 설치 경로

`releases/latest/download/install-cli.*` one-liner는 짧지만 재현성이 낮습니다. 최신
unsigned bootstrap을 바로 실행하므로 wheel은 검증해도 bootstrap script 자체는
검증하지 않습니다. 무결성과 재현성이 중요하면 위 버전 고정 경로를 사용하세요.

## 다음 릴리스 후보의 변경 사항

다음 후보의 기능은 성숙도에 따라 구분합니다. 코드가 구현됐다는 사실이 실제 환경이나
운영 환경에서 검증됐다는 뜻은 아닙니다.

### 후보 버전에서 검증 완료

- **안전한 프로젝트 유지보수** — `cascade sync`가 origin hash로 사용자 수정 파일을
  보존하고, 쓰기 직전에 다시 검증하며, 건너뛴 모든 경로와 사유를 보고합니다.
  `/new --upgrade`는 먼저 진단하고 Toolkit 관리 파일을 백업하며 실패한 transaction을
  원복합니다.
- **증거 기반 워크플로** — `/review`가 diff, Goal, 수용 기준, 검증 증거, 검토한
  commit과 plan 장부를 하나의 변경 집합으로 연결합니다. `/handoff`는 활성 맥락을
  보존하고 설정된 Graph index 중 stale한 항목만 갱신하며, 갱신 실패로 handoff를
  차단하지 않습니다.
- **Memtemple 연속성** — 공식 memory 경로를 `atomy-toolkit memtemple`로 통일했고
  legacy Mempalace 라이브러리와 과거 embedding shim을 제거했습니다.
- **Project Intelligence Graph** — 결정적 코드 index, 코드-결정 연결, 영향 범위 조회,
  승인 기반 judge 화면이 포함된 독립 실행형 Graph Report를 제공합니다.
- **로컬 통제 기능** — opt-in·network-free 명령 telemetry, 결정적 audit 알림,
  보호된 skill intake primitive와 offline project rulepack 검사를 제공합니다.
- **검증된 어댑터 경로** — Claude Code, Codex, Cursor와 Claude Desktop MCP 설정
  경로는 각각 정의된 검증을 완료했습니다.
- **배포 위생** — clean-slate 패키징, secret/leak guard, Toolkit 기본 파일의 가역적
  폐기, MPL-2.0 의존성이 없는 Graph Report를 적용했습니다.

### Preview

- **Rulepack 협업** — Codex와 Claude의 2-worktree 로컬 파일럿은 완료했지만, 원격
  협업과 운영 rollout은 검증하지 않았습니다.
- **Knowledge Fabric federation** — 로컬 loopback과 임시 기기간 전송을
  검증했습니다. 지원되는 운영 hub는 아직 없으며, 시험에 사용한 원격 장치는 임시
  테스트 자원이었습니다.
- **Absence Batch와 Research Relay** — 격리된 draft-PR-only 계약을 구현했습니다.
  최초 외부 live E2E와 예약 실행은 남아 있습니다.

### Experimental

- **`/delegate` 야간 자동화** — 서명된 행동 봉투, 격리 worktree, worker sandbox,
  controller-only 자격증명, 아침 `GO`/`NO-GO` 흐름은 구현 및 회귀 검증을
  마쳤습니다. 실제 첫 full-night 실행은 아직 남아 있습니다.
- **Antigravity와 Cowork 어댑터** — 설치·capability 표면은 존재하지만
  Antigravity는 workflow routing revision이 필요하고 Cowork는 live smoke를 완료하지
  않았습니다.
- **Skill lifecycle/intake 변경 기능** — API는 fixture에서 검증했지만 실제 설치
  skill 이동·활성화, downstream 공유와 사용자 memory 변경은 실행하지 않았습니다.
  자동 이동은 꺼져 있습니다.

Preview와 Experimental은 운영 지원을 약속하는 기능이 아닙니다. commit이나 원격 효과를
만들 수 있는 자동화는 격리된 non-default branch에서 사용해야 하며 최초 실행에는 사람의
검수가 필요할 수 있습니다.

## 중요한 제한사항

- 이 후보에서 `atomy-toolkit update`와 `update rollback`은 실제 패키지 교체·복원
  경로가 아닙니다. 현재는 버전 확인과 사용자 확인을 위한 골격만 제공합니다.
- 후보의 origin-hash 보호 `cascade sync`는 공개 `v0.3.1` wheel에 없습니다. 현재
  공개 버전에 같은 보호 기능이 있다고 가정하지 마세요.
- Preview 자동화는 자동 merge, 보호/default branch 쓰기, production endpoint 배포를
  수행하지 않습니다.
- cloud telemetry는 없습니다. Toolkit telemetry는 로컬 전용·opt-in·network-free입니다.
- `v0.1.0` Windows/macOS native artifact는 과거 unsigned 테스트 산출물입니다.
  `v0.2.0` 이후 공식 공개 경로는 wheel과 위 command installer입니다.

## v0.3.1에서 사용할 수 있는 기본 명령

```bash
atomy-toolkit --version
atomy-toolkit doctor
atomy-toolkit install ./my-project
atomy-toolkit memtemple --help
```

후보 전용 command와 workflow 표면은 패치 노트에 설명했습니다. 새 release asset을
발행하기 전에는 공개 installer로 받을 수 없습니다. 특히 `atomy-toolkit graph`는 공개
`v0.3.1` wheel에 없습니다. 당시에도 이전 형태의 `/delegate` workflow는 있었지만,
후보의 봉인된 감독형 야간 실행 기능은 포함되지 않았습니다.

## 버전 표기

`v0.3.1` 같은 GitHub tag는 공개 Toolkit 제품 릴리스입니다. 과거 cascade
metadata에 있던 `1.0.0`은 별도의 내부 자산 버전 계보이며, 공개 Toolkit
`v1.0.0` 릴리스를 의미하지 않습니다.

## 무결성과 개인정보 보호

- 권장 버전 고정 경로는 bootstrap script hash를 검증하고, bootstrap은 공개된
  SHA256 파일로 wheel을 검증합니다.
- 편의 one-liner는 bootstrap script 자체를 검증하지 않습니다.
- clean-slate 패키징은 소스 이력, 자격증명, 로컬 memory, runtime 상태와 진행 중인
  프로젝트 문서를 제외합니다.
- 이 공개 저장소에는 비공개 소스 트리가 포함되지 않습니다.
- 현재 공개 `v0.3.1` wheel과 command installer는 서명되지 않았습니다. 위의 버전 고정
  hash를 현재 공개 릴리스의 무결성 통제로 사용합니다.
