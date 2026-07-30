# Atomy Toolkit

[English](README.md) | 한국어

**AI에게 개발을 시킬 때, 매번 처음부터 설명하지 않아도 되게 해주는 도구예요.**

Claude Code 같은 AI 코딩 도구를 쓰다 보면 이런 일이 생깁니다. 어제 정한 걸 오늘 또
설명하고, AI가 "다 됐습니다"라고 했는데 실제로는 안 돌아가고, 대화창을 새로 열면 여태
쌓은 맥락이 사라지죠.

Atomy Toolkit을 프로젝트에 한 번 깔아두면:

- **AI가 어제 한 일을 기억합니다** — 무엇을 왜 그렇게 정했는지 기록해두고 다음 대화에서 알아서 꺼내 씁니다.
- **"됐습니다"를 함부로 못 합니다** — 테스트를 실제로 돌려 결과를 보여주기 전에는 완료라고 말하지 않게 규칙이 걸립니다.
- **일하는 순서가 정해집니다** — 조사 → 계획 → 승인 → 구현. 계획을 보고 "그거 말고"라고 할 기회가 생깁니다.
- **내 컴퓨터 안에서만 돕니다** — 서버로 보내는 게 없습니다.

> 💡 **누구를 위한 도구인가요?**
> 코딩을 직접 하지 않는 분이 AI와 함께 결과물을 만들고, 나중에 개발자에게 넘기는 상황을
> 염두에 두고 만들었습니다. 개발자에게도 물론 쓸모 있습니다.

---

## 지금 버전

- 최신 공개 버전: **[v0.4.0](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.4.0)** (2026-07-30)
- 직전 버전 `v0.3.1`과 비교한 변경점: [한국어 패치 노트](PATCH_NOTES.ko.md) · [English](PATCH_NOTES.md)

이 저장소에는 설치 파일과 문서만 있습니다. 프로그램 소스 코드는 비공개입니다.

---

## 설치하기

### 먼저 준비물 확인

컴퓨터에 **Python 3.12 이상**이 필요합니다. 터미널(Windows는 PowerShell)에 이렇게 쳐보세요.

```bash
python3 --version
```

`Python 3.12.x` 처럼 나오면 준비 완료입니다. "명령을 찾을 수 없다"고 나오거나 숫자가
3.12보다 낮으면 [python.org](https://www.python.org/downloads/)에서 먼저 설치하세요.

> 설치 파일은 Python을 대신 깔아주지 않습니다. 없으면 그냥 멈추고 안내만 합니다.
> (`uv`라는 도구가 이미 있다면 그걸로도 됩니다.)

### 설치 명령

아래를 **그대로 복사해서 붙여넣으세요.** 3줄이 한 세트입니다.

<!-- markdownlint-disable MD013 -->

**Windows (PowerShell)**

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.ps1 -OutFile install-cli.ps1
$expected = "0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

**macOS**

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

**Linux**

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/install-cli.sh
echo "c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

<!-- markdownlint-enable MD013 -->

<details>
<summary><b>중간에 왜 이상한 문자열을 확인하나요?</b> (클릭해서 펼치기)</summary>

가운데 줄은 **받은 파일이 진짜 우리가 올린 파일인지 확인**하는 절차입니다. 파일마다
지문 같은 값(SHA256)이 있는데, 그게 우리가 공개한 값과 다르면 중간에 누가 바꿔치기한
것이므로 설치를 멈춥니다.

그래서 "인터넷에서 받은 걸 바로 실행"하지 않고 **① 파일로 저장 → ② 지문 확인 →
③ 실행** 순서로 나눠 뒀습니다. 한 줄로 줄이면 편하지만 이 확인을 건너뛰게 됩니다.

지문이 다르다고 나오면 설치하지 마시고 알려주세요.

</details>

### 설치되면 무슨 일이 일어나나요

프로그램은 **다른 프로그램과 섞이지 않는 별도 공간**에 설치됩니다. 컴퓨터에 이미 깔린
Python 환경을 건드리지 않으니 안심하셔도 됩니다.

설치 확인:

```bash
atomy-toolkit --version
```

문제가 있는지 스스로 점검하게 하려면:

```bash
atomy-toolkit doctor
```

### 첫 프로젝트 만들어보기

```bash
atomy-toolkit install ./my-project
```

이러면 `my-project` 폴더에 AI가 참고할 규칙과 기록 공간이 자동으로 만들어집니다.
이후 그 폴더에서 Claude Code를 열고 `/rpi` 라고 쳐보세요. 조사 → 계획 → 구현 순서로
일이 진행됩니다.

더 자세한 설치 옵션은 [INSTALL.md](INSTALL.md), 전체 검증 절차는
[공개 설치 가이드](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md)에 있습니다.

---

## v0.4.0에서 좋아진 것

기능마다 **어디까지 확인됐는지**를 솔직하게 표시했습니다.

| 표시 | 뜻 |
|---|---|
| ✅ **검증 완료** | 테스트를 통과했습니다. 편하게 쓰세요. |
| 🟡 **미리보기** | 실제로 써봤지만 아직 다듬는 중입니다. 확인해가며 쓰세요. |
| 🧪 **실험 중** | 첫 실전 사용이 아직입니다. 중요한 일에는 쓰지 마세요. |

### ✅ 업데이트해도 내가 고친 파일이 날아가지 않습니다

전에는 툴킷을 새 버전으로 올리면 내가 손댄 설정까지 기본값으로 되돌아갈 위험이 있었어요.
이제는 **툴킷이 처음 준 그대로인지, 내가 바꿨는지 구분해서** 내가 바꾼 건 건드리지 않습니다.
바꾸기 전에 "이 파일을 이렇게 바꿀 예정"을 먼저 보여주고, 건너뛴 파일은 이유까지 알려줍니다.

> ⚠️ **아직 못 하는 것** — 내 수정과 새 버전을 **자동으로 합쳐주지는** 못합니다(둘 중 하나를
> 고릅니다). 업데이트가 끝난 뒤 누르는 "되돌리기" 버튼도 없습니다. 되돌리려면 자동으로
> 만들어 둔 백업 폴더를 직접 복사해야 합니다.

### ✅ "다 됐습니다"에 증거가 붙습니다

AI가 작업을 마쳤다고 할 때, **무엇을 고쳤고 테스트가 실제로 통과했는지**를 함께 묶어서
기록합니다. 검토를 통과하지 못한 작업은 완료 표시가 되지 않습니다.

### ✅ 대화를 새로 열어도 맥락이 이어집니다

어제 정한 것, 하다 만 것, 조심해야 할 것을 정리해두고 다음 대화에서 자동으로 꺼내 옵니다.
오래된 기록은 알아서 정리하되, **아직 진행 중인 일은 지우지 않고 남깁니다.**

### ✅ 프로젝트 구조를 그림과 보고서로 봅니다

코드와 결정이 어떻게 연결돼 있는지 훑어보는 화면을 제공합니다. 인터넷 연결 없이 열리는
파일 하나로 나옵니다.

### ✅ 기록은 내 컴퓨터에만 남습니다

사용 기록을 서버로 보내지 않습니다. 켤지 말지는 직접 고르고, 켜더라도 **내가 입력한 내용,
파일 경로, 프로젝트 이름은 저장하지 않습니다.**

### 🟡 밤새 대신 일 시키기 (`/delegate`)

퇴근할 때 켜 둔 **내 컴퓨터**에서 밤새 작업을 진행시키는 기능입니다(운영 서버용이 아닙니다).
할 수 있는 일을 미리 정해 봉인하고, 격리된 작업 공간에서만 돌리고, 아침에 사람이
`GO`/`NO-GO`를 결정합니다. **실제로 하룻밤을 처음부터 끝까지 돌려봤습니다.**

### 🟡 그 밖의 미리보기 기능

- **팀 규칙 자동 점검** — 두 개의 AI 도구로 같은 규칙을 검사하는 실험까지 마쳤지만, 여러 명이 함께 쓰는 상황은 아직 확인 전입니다.
- **기록을 여러 기기에서 나눠 쓰기** — 같은 네트워크 안에서 주고받는 것까지 확인했습니다. 시험에 쓴 장비는 그냥 그때 쓸 수 있던 다른 PC였고, 운영 서버가 아닙니다.
- **자리 비운 사이 처리 / 자료 조사 이어달리기** — 안전장치를 걸어 만들었지만 실제 예약 실행은 아직입니다.

### 🧪 실험 중인 기능

- **Antigravity·Cowork 연동** — 설치는 되지만 실사용 확인이 더 필요합니다.
- **기능 자동 승격** — 기본으로 꺼져 있습니다.

> 🟡와 🧪 기능은 운영 지원을 약속하지 않습니다. 바깥에 영향을 주는 자동화는 격리된
> 작업 공간에서만 돌고, **마지막 확정은 반드시 사람이 합니다.**

---

## 이 도구가 하지 않는 일

기대하지 않으셔야 할 것들을 미리 적어둡니다.

- **`atomy-toolkit update` 는 아직 진짜 업데이트가 아닙니다.** 관리 파일을 최신으로 맞추려면 `atomy-toolkit cascade sync` 를 쓰세요.
- **혼자 판단해서 코드를 합치거나, 중요한 브랜치에 쓰거나, 실제 서비스에 배포하지 않습니다.**
- **사용 기록을 클라우드로 보내지 않습니다.** 전부 내 컴퓨터 안에서만 돕니다.
- **내 기록을 서버에서 대신 처리해주는 서비스는 없습니다.** 나중에 만들지 검토 중인 별개 과제이고, v0.4.0에는 없습니다.

---

## 자주 쓰는 명령

```bash
atomy-toolkit --version          # 버전 확인
atomy-toolkit doctor             # 문제 자가 점검
atomy-toolkit install ./my-project   # 프로젝트에 설치
atomy-toolkit memtemple --help   # 기억 저장소
atomy-toolkit graph --help       # 프로젝트 구조 보기
```

---

<details>
<summary><b>기술 상세</b> — 설치 파일 지문, 버전 표기 규칙 (클릭해서 펼치기)</summary>

### 릴리스 파일과 무결성

v0.4.0 GitHub Release asset은 정확히 4개입니다.

| Asset | SHA256 |
|---|---|
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` | `bd90615f04c647a0d3e004ea75e65bb18bad3467a335316b0d9883c079c2043a` |
| `SHA256.txt` | `563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d` |
| `install-cli.sh` | `c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc` |
| `install-cli.ps1` | `0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804` |

`SHA256.txt` 에는 wheel과 installer 2개의 hash가 들어 있습니다. checksum 파일은 자기
자신의 안정적인 hash를 포함할 수 없으므로 `SHA256.txt` 의 hash는 위 표에 별도로 제공합니다.

asset은 서명되지 않았습니다. 위 고정 hash가 릴리스 무결성 통제입니다. `.exe`, `.pkg`,
`.dmg`, `.AppImage` 는 v0.4.0 공식 배포 경로에 포함되지 않습니다.

bootstrap은 고정된 `atomy_toolkit_lib-0.4.0-py3-none-any.whl` 만 다운로드하고 내장
SHA256을 검증합니다. 그 뒤 격리된 virtual environment에 설치하고
`atomy-toolkit self-install` 을 실행합니다. system site-packages에는 설치하지 않습니다.

- source commit: `f321cc47045bec5c0b08f05163fec2e44bc408f4`
- Graph Report는 Playwright `1.62.0` 을 직접 development dependency로 고정합니다.
  Playwright는 runtime wheel에 포함되지 않습니다.

### 버전 표기

`v0.4.0` 같은 GitHub tag가 공개 제품 릴리스입니다. 과거 cascade metadata의 `1.0.0` 은
별도 내부 asset 버전 계보이며 공개 `v1.0.0` 릴리스를 의미하지 않습니다. 이 wheel의
cascade master metadata는 `1.1.3` 입니다.

</details>

---

## 라이선스와 개인정보

Atomy Toolkit v0.4.0은 [MIT License](LICENSE)로 배포합니다. [NOTICE](NOTICE)와
[Graph Report 고지](THIRD_PARTY_NOTICES.md)에 사용한 외부 자료를 표시했습니다.

이 공개 저장소에는 비공개 소스가 들어있지 않습니다. 패키징 과정에서 개발 이력, 자격증명,
로컬 기억, 세션·로그, 백업, 진행 중인 문서를 전부 제외합니다.
