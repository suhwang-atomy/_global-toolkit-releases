# Atomy Toolkit

**AI에게 일을 맡길 때, 옆에서 꼼꼼히 챙겨 주는 도우미입니다.**
Claude Code·Codex·Antigravity 같은 AI 코딩 도구에 붙여서 씁니다. 개발자가 아니어도 됩니다.

AI는 대체로 잘 만들지만, 잘 만들었는지는 아무도 확인하지 않는 경우가 많습니다.
"다 됐습니다" 했는데 돌려 보면 안 되고, 비밀 정보가 코드에 섞이고, 어제 왜 그렇게 정했는지 오늘은 아무도 모릅니다.
이 도구는 그 빈틈을 채웁니다.

## 이 도구가 챙겨 주는 것

| 챙기는 것 | 하는 일 |
|---|---|
| 시작 전에 정리 | 바로 만들지 않고 "무엇을, 왜"부터 묻고 계획을 세운 뒤 확인을 받습니다 |
| 완료 확인 | "다 됐어요"라는 말 대신, 실제로 돌린 검사 결과가 있어야 끝난 것으로 봅니다 |
| 위험한 일 앞에서 멈춤 | 대량 삭제·배포·외부 전송·출시 같은 되돌리기 어려운 일은 하기 전에 사람에게 묻습니다 |
| 기억 | 왜 그렇게 정했는지 기록해 두고, 다음 대화에서 이어서 꺼내 씁니다 |
| 인계 | 하루를 마칠 때 다음 사람(또는 내일의 나)에게 넘길 기록을 남깁니다 |

## 일하는 방식

명령은 AI 앱의 대화창에 입력합니다. 하루 일은 대개 이 순서로 흘러갑니다.

1. **처음 한 번 — `/new`**
   새 프로젝트를 시작합니다. 어떤 일인지(개발인지 문서 업무인지, 여러 문서가 서로 얽혀 있는지) 몇 가지 묻고
   폴더와 기본 문서를 만들어 줍니다. 이미 있는 폴더에 붙일 때는 터미널에서 `atomy-toolkit install .`을 실행합니다.
2. **시작 — `/rpi`**
   오늘 할 일을 정합니다. 조사 → 계획 → 실행 순서로 가고, 계획은 확인을 받은 뒤 실행합니다.
3. **확인 — `/review`**
   만든 것을 검사합니다. 검사 결과가 완료의 근거로 남습니다.
4. **마무리 — `/handoff`**
   한 일·남은 일·다음 첫 작업을 기록하고 대화를 저장합니다. 메모가 길어지면 끝난 내용은 보관함으로 옮겨
   다음 대화가 가볍게 시작하도록 정리합니다. 지우지 않고 옮깁니다.

필요할 때 쓰는 명령도 있습니다.

| 명령 | 언제 |
|---|---|
| `/status` | 아침에 어디까지 했는지 볼 때 |
| `/undo` | 방금 한 일을 되돌리고 싶을 때 |
| `/sos` | 오류가 났는데 무슨 뜻인지 모를 때 |
| `/plandoc` | 기획 문서를 정리·점검할 때 |
| `/cost` | AI 사용 비용이 궁금할 때 |
| `atomy-toolkit doctor` (터미널) | 설치·연결 상태를 점검할 때 |

## 안전장치

- 되돌리기 어려운 행동 직전에 승인 창이 뜹니다. 대량 삭제, DB 구조 변경, 배포, main 가지에 바로 올리기, 외부 전송, 출시 이름표 올리기가 대상입니다.
- 보호 단계는 `atomy-toolkit protection set off|default|strict`로 바꿉니다. 낮추기는 사람이 터미널에서 화면의 숫자를 직접 입력해야만 됩니다.
- 기밀 등급 자료를 밖으로 보내려는 명령은 막습니다.
- 사용자의 기존 설정과 파일은 덮어쓰지 않습니다. 바꿔야 할 때는 복구본을 남깁니다.

## 설치하고 시작하기

아래 설치 안내를 따라 설치한 뒤:

1. 새 터미널에서 `atomy-toolkit doctor`로 연결 상태를 확인합니다.
2. 열어 둔 AI 앱을 완전히 닫았다가 다시 엽니다.
3. 새 프로젝트는 AI 앱에서 `/new`, 기존 폴더는 그 폴더의 터미널에서 `atomy-toolkit install .`로 시작합니다.
4. 이미 툴킷을 쓰던 프로젝트는 `atomy-toolkit cascade sync`로 새 판의 파일을 받습니다.

지원 환경은 macOS·Linux·Windows(x64)입니다. Windows ARM 기기에서는 ARM용 Python으로 설치되지 않습니다(필요한 보안 부품의 ARM 판이 아직 없음). x64용 Python 3.12를 깔아 쓰면 설치됩니다.
판마다 달라진 점은 [패치 노트](https://github.com/suhwang-atomy/_global-toolkit-releases/blob/main/PATCH_NOTES.ko.md)에 있습니다.

---

# Atomy Toolkit 0.6.0 설치 안내

이 안내와 설치 파일은 `release-manifest.json`에서 함께 생성했습니다.
Python 3.12 이상 또는 미리 설치한 uv가 필요합니다.
설치 파일을 내려받고 내용이 일치하는지 확인한 뒤 실행하세요.

## Linux

```sh
curl -fL -o install-cli.sh 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.6.0/install-cli.sh'
echo '5c5f18b26ea67dc77da9bc5679add70c6c1903210b831e0ea0bcebbfc10caa86  install-cli.sh' | sha256sum -c - && sh ./install-cli.sh
```

## macOS

```sh
curl -fL -o install-cli.sh 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.6.0/install-cli.sh'
echo '5c5f18b26ea67dc77da9bc5679add70c6c1903210b831e0ea0bcebbfc10caa86  install-cli.sh' | shasum -a 256 -c - && sh ./install-cli.sh
```

## Windows PowerShell

```powershell
Invoke-WebRequest -Uri 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.6.0/install-cli.ps1' -OutFile install-cli.ps1
if ((Get-FileHash ./install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant() -ne '6c6ad1ddfccf470d125ff595193a23741ca2b2f987dbf00f7eeb19b5e370e7da') { throw '설치 파일 내용이 다릅니다.' }
& ./install-cli.ps1
```

## 설치 선택

기본 설치는 Claude Code와 Codex의 연결을 등록합니다.
`ATOMY_TOOLKIT_CODING_TOOL`은 `codex` 또는 `skip`을 선택할 수 있습니다.
`ATOMY_TOOLKIT_IDE_TOOL`은 `antigravity` 또는 `skip`을 선택할 수 있으며 기본은 `skip`입니다.
VS Code 자동 등록은 지원하지 않습니다. 미지원 선택은 설치 오류로 알립니다.
설치 위치는 `ATOMY_TOOLKIT_INSTALL_ROOT`로 바꿀 수 있으며 기본은 사용자 홈의 `atomy-toolkit`입니다.
선택을 바꾸려면 설치 파일 실행 전에 해당 환경변수를 설정하세요.

필수 연결 부품 `[mcp]`를 배포 파일과 같은 실행 공간에 설치합니다.
재설치는 별도 실행 공간을 만들며 기존 실행 공간을 덮지 않습니다.
기존 설정과 사용자 자료는 보존하고 교체할 파일의 복구본을 남깁니다.
설정 등록과 실제 연결 검사에 실패하면 설치 완료로 표시하지 않습니다.

## 설치 후 확인

새 터미널에서 `atomy-toolkit doctor`로 연결 상태를 확인하세요.
기존에 열어 둔 AI 앱은 다시 시작해야 새 연결과 안내를 읽습니다.
설치기의 연결 검사는 앱 화면에서 실제 사용한 것과 별도로 기록합니다.
프로젝트 폴더에서 `atomy-toolkit install .`을 실행한 뒤 AI 앱에서 `/rpi`로 시작하세요.

## 이번 배포 파일

- 버전: `0.6.0`
- 파일: `atomy_toolkit_lib-0.6.0-py3-none-any.whl`
- 주소: https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.6.0/atomy_toolkit_lib-0.6.0-py3-none-any.whl
- 내용 확인값(SHA256): `e5d1a36114d13977e82810873bf6d1c04a46c0c1d17987b9f5b43abc606b5c8f`
- 설치 파일의 확인값과 앱 선택 목록: `release-manifest.json`

공개 저장소의 README·상세 안내·루트 설치 파일을 갱신할 때는 같은 배포의
`public-source.zip`을 사용하세요. 이 파일 생성만으로 원격 공개 배포가 실행되지는 않습니다.
