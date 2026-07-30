# Atomy Toolkit 릴리스

[English](README.md) | 한국어

Atomy Toolkit의 공개 clean-slate 배포 저장소입니다. Atomy Toolkit은 여러 코딩
도구에서 에이전틱 소프트웨어 개발 흐름을 일관되게 사용할 수 있도록 구성한 로컬 우선
워크플로 툴킷입니다.

소스 저장소는 비공개입니다. 이 저장소에는 공개 installer, checksum, 릴리스 문서와
재배포에 필요한 라이선스 고지만 포함됩니다.

> **현재 릴리스**
>
> - 현재 공개 최신 버전:
>   [v0.4.0](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.4.0)
> - 비교 기준: 공개 `v0.3.1`
> - source commit: `30c7e26a9a023c598a498b24157c418ed660e4fe`
> - 상세 변경: [한국어 패치 노트](PATCH_NOTES.ko.md) ·
>   [English patch notes](PATCH_NOTES.md)

## v0.4.0 설치

### 사전 조건

다음 중 하나가 필요합니다.

- `PATH`에서 사용할 수 있는 Python 3.12 이상
- `PATH`에 미리 설치했거나 `ATOMY_TOOLKIT_UV_BIN`으로 지정한 `uv`
  (`uv`가 Python 3.12를 준비)

installer는 Python 또는 `uv` installer를 다운로드하거나 실행하지 않습니다. 둘 다
없으면 실행을 중단하고 Python과 `uv`의 공식 설치 페이지를 안내합니다.

### 다운로드, 검증, 실행

다운로드한 script를 shell에 바로 연결하지 마세요. v0.4.0에 고정된 installer를 파일로
저장하고 hash를 검증한 뒤, 검증한 로컬 파일을 실행하세요.

<!-- markdownlint-disable MD013 -->

Linux:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c0f69359660310a6baeecfdc338eaecce0669a56e097a6f3c4da57653d58923c  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

macOS:

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c0f69359660310a6baeecfdc338eaecce0669a56e097a6f3c4da57653d58923c  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

Windows 11 PowerShell:

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.ps1 -OutFile install-cli.ps1
$expected = "b986da519b3b04725895aa82a02a03de64e802ed52db8ada98bc5aea1ca3a1ea"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

<!-- markdownlint-enable MD013 -->

bootstrap은 고정된 `atomy_toolkit_lib-0.4.0-py3-none-any.whl`만 다운로드하고 내장
SHA256을 검증합니다. 그 뒤 격리된 virtual environment에 설치하고
`atomy-toolkit self-install`을 실행합니다. system site-packages에는 설치하지 않습니다.

옵션은 [INSTALL.md](INSTALL.md), 전체 검증 절차는
[공개 설치 가이드](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md)를 참고하세요.

## 릴리스 asset과 무결성

v0.4.0 GitHub Release asset은 정확히 4개입니다.

| Asset | SHA256 |
|---|---|
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` | `6a9097f2be443192db66fa5f038b435b391549760641878db109525330321297` |
| `SHA256.txt` | `d9152e55afb076fd082fbfa4e351b67c31d86730cb2121f5899ecb0a10d25847` |
| `install-cli.sh` | `c0f69359660310a6baeecfdc338eaecce0669a56e097a6f3c4da57653d58923c` |
| `install-cli.ps1` | `b986da519b3b04725895aa82a02a03de64e802ed52db8ada98bc5aea1ca3a1ea` |

`SHA256.txt`에는 wheel과 command installer 2개의 hash가 들어 있습니다. checksum
파일은 자기 자신의 안정적인 hash를 포함할 수 없으므로 `SHA256.txt`의 hash는 위 표에
별도로 제공합니다.

asset은 서명되지 않았습니다. 위 고정 hash가 릴리스 무결성 통제입니다. `.exe`, `.pkg`,
`.dmg`, `.AppImage`는 v0.4.0 공식 배포 경로에 포함되지 않습니다.

## v0.4.0의 변경 사항

기능은 성숙도에 따라 구분합니다. 구현됐다는 사실이 실제 환경이나 운영 환경에서
검증됐다는 뜻은 아닙니다.

### 검증 완료

- **안전한 프로젝트 유지보수** — `cascade sync`가 origin hash로 사용자 수정 파일을
  보존하고 쓰기 직전에 다시 검증하며 skip 경로를 보고합니다. `/new --upgrade`는 먼저
  진단하고 관리 파일을 백업하며 실패한 transaction을 원복합니다.
- **증거 기반 워크플로** — `/review`가 diff, Goal, 수용 기준, 검증 증거, 검토한
  commit과 plan 장부를 연결합니다. `/handoff`는 활성 맥락을 보존하고 설정된 Graph
  index 중 stale한 항목만 갱신합니다.
- **Memtemple 연속성** — 공식 memory 인터페이스를
  `atomy-toolkit memtemple`로 통일했고 legacy Mempalace 라이브러리와 과거 embedding
  shim을 제거했습니다.
- **Project Intelligence Graph** — 결정적 index, 영향 범위 조회, 승인 기반 judge
  화면을 포함한 독립 실행형 offline Graph Report를 제공합니다.
- **로컬 통제 기능** — opt-in·network-free command telemetry, 결정적 audit 알림,
  보호된 skill-intake primitive와 offline rulepack 검사를 제공합니다.
- **릴리스 compliance** — clean-slate 패키징이 source history, 자격증명, local
  memory와 runtime state를 제외합니다. Graph Report는 runtime package record 35개의
  고지를 포함하며 설치된 MPL 라이선스 package record는 0개입니다.

### Preview

- **Rulepack 협업** — Codex와 Claude의 2-worktree 로컬 파일럿은 완료했지만, 원격
  협업과 다중 사용자 rollout은 검증하지 않았습니다.
- **Knowledge Fabric federation** — 로컬 loopback과 임시 기기간 전송을
  검증했습니다. 시험에 사용한 DGX는 당시 이용할 수 있었던 다른 PC였으며 운영 서버나
  production server가 아니었습니다.
- **Absence Batch와 Research Relay** — 격리된 draft-PR-only 계약을 구현했습니다.
  최초 외부 live E2E와 예약 실행은 남아 있습니다.

### Experimental

- **`/delegate` 감독형 야간 자동화** — 의도한 host는 Toolkit이 설치되고 capability
  검사를 통과한 장치입니다. 예를 들어 퇴근할 때 켜 둔 workstation을 사용할 수 있으며
  운영 서버 기능이 아닙니다. 봉인된 행동표, 격리 worktree, worker sandbox,
  controller-only 자격증명과 아침 `GO`/`NO-GO` 흐름은 구현했지만 첫 실제 full-night
  실행은 남아 있습니다.
- **Antigravity와 Cowork 어댑터** — 설치·capability 표면은 있지만 추가 live 검증이
  필요합니다.
- **Skill lifecycle 변경 기능** — API는 fixture에서 검증했으며 자동 이동과 승격은
  꺼져 있습니다.

Preview와 Experimental은 운영 지원을 약속하는 기능이 아닙니다. 원격 효과를 만들 수
있는 자동화는 격리된 non-default branch에서 수행하고 사용자가 명시적으로 최종
확정해야 합니다.

## 중요한 제한사항

- v0.4.0의 `atomy-toolkit update`와 `update rollback`은 실제 package 교체·복원
  경로가 아닙니다. 관리 asset 유지보수에는 `atomy-toolkit cascade sync`를 사용합니다.
- Toolkit은 자동 merge, 보호/default branch 쓰기 또는 production endpoint 배포를
  수행하지 않습니다.
- cloud telemetry는 없습니다. Toolkit telemetry는 로컬 전용·opt-in·network-free입니다.
- 사용자가 제공한 Memtemple 기록의 embedding을 중앙에서 일괄 처리하는 서비스는 별도
  미래 과제입니다. Railway 또는 AWS hosting과 cascade patch/update service 가능성도
  이후 설계·검증할 과제이며 v0.4.0이 제공하거나 운영하지 않습니다.

## 기본 명령

```bash
atomy-toolkit --version
atomy-toolkit doctor
atomy-toolkit install ./my-project
atomy-toolkit memtemple --help
atomy-toolkit graph --help
atomy-toolkit afk --help
```

## 버전 표기

`v0.4.0` 같은 GitHub tag는 공개 Toolkit 제품 릴리스입니다. 과거 cascade metadata의
`1.0.0`은 별도 내부 asset 버전 계보이며 공개 Toolkit `v1.0.0` 릴리스를 의미하지
않습니다.

## 라이선스, 고지와 개인정보 보호

Atomy Toolkit v0.4.0은 [MIT License](LICENSE)로 배포합니다. [NOTICE](NOTICE)는
adapted engineering-discipline material을 표시하고,
[Graph Report third-party notices](THIRD_PARTY_NOTICES.md)는 runtime 및 development
package record를 제공합니다.

이 공개 저장소에는 비공개 source tree가 포함되지 않습니다. clean-slate 패키징은
source history, 자격증명, local memory, session/log 상태, backup과 진행 중인 프로젝트
문서를 제외합니다.
