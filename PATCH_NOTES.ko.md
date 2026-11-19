# Atomy Toolkit 0.8.0 — Python이 없어도 설치 명령 한 번으로 끝까지

0.7.0 이후 달라진 점입니다. 이번 판은 처음 설치하는 사람이 가장 많이 막히던 자리, "Python 3.12 이상이 필요합니다"를 없애는 데 집중했습니다.

## 새 기능

- **Python 3.12 이상이 없어도 설치가 끝까지 갑니다.** Python 3.12 이상도 uv도 없는 컴퓨터에서 설치 명령이 멈추지 않습니다.
  묻지 않고 uv 0.13.7을 받아, 설치 파일에 미리 적어 둔 확인값과 대조한 뒤에만 실행합니다. 그 uv로 Python 3.12를 사용자 폴더에 마련하고
  설치를 이어 갑니다. 관리자 암호는 묻지 않고, 원래 있던 Python은 건드리지 않습니다.
- **무엇을 어느 판으로 받았는지 화면에 남습니다.** 받기 전, 받은 뒤, Python을 마련한 뒤에 한 줄씩 나옵니다.
- 받은 uv는 `~/.local/bin/uv`(Windows는 `~\.local\bin\uv.exe`)에 남습니다. 다시 설치하거나 판을 올릴 때 또 받지 않습니다.
- ARM 기기의 Windows에서는 x64 Python을 받습니다. 툴킷 부품 하나에 ARM용 완성본이 없기 때문입니다.

## 고친 점

- **uv로 Python을 받은 컴퓨터에서 AI 도구의 명령이 모두 막히던 문제를 고쳤습니다.** 기밀등급 차단 훅이 uv를 찾는 길(PATH)에서만 찾았습니다.
  Mac은 `~/.local/bin`을 찾는 길에 넣지 않고, Dock에서 켠 AI 앱은 셸 설정도 읽지 않습니다. 이제 차단 훅과 묻기 훅이 그 자리를 직접 봅니다.
  기존 프로젝트의 훅은 `atomy-toolkit cascade sync`·`install`·`doctor` 때, 툴킷이 내보낸 글자 그대로일 때만 새 본문으로 바뀝니다.
  직접 손댄 훅은 바꾸지 않고 알리기만 합니다.
- `/rpi` 없이 일한 대화도 `/handoff`로 마감할 수 있습니다. 마감 요청의 `session_id`에 `"auto"`를 넣으면 세션을 열어 닫습니다.
  감사 판정과 근거를 마감 기록에 남길 수 있습니다.

## 받지 않게 하려면

`ATOMY_TOOLKIT_NO_UV=1`을 설정하고 Python 3.12 이상을 직접 설치하세요. 이때만 설치 파일이 아무것도 받지 않습니다.
회사 안에 거울 서버가 있으면 `ATOMY_TOOLKIT_UV_DOWNLOAD_BASE`와 `ATOMY_TOOLKIT_UV_SHA256`으로 바꿀 수 있습니다. 바꾸면 경고 한 줄이 나옵니다.

## 받는 것의 출처

uv(Apache-2.0 또는 MIT)와 python-build-standalone의 CPython(PSF 허가, 부품별 허가 동봉)은 툴킷 꾸러미에 들어 있지 않습니다.
설치하는 컴퓨터가 각 프로젝트의 공식 배포처(github.com)에서 직접 받습니다. 자세한 내용은 `NOTICE`에 있습니다.

## 확인 범위와 알려진 한계

- Mac(Apple 실리콘)과 Windows 11(ARM, x64 Python)에서 Python과 uv가 없는 상태를 만들어 실제로 끝까지 설치했습니다.
  Windows는 원래 Python이 있는 가상 컴퓨터라, 시험 때만 uv가 받은 Python만 쓰게 했습니다.
- x64 Windows 실기기와 Intel Mac에서는 실제 설치를 돌리지 않았습니다. 확인값은 각 배포처가 낸 값과 대조해 적었습니다.
- github.com 접속이 막힌 회사 망에서는 받기가 실패하고, 한국어로 원인과 다음 할 일을 알립니다.
- 공식 사내 규정이 바깥 프로그램 자동 받기를 허용하는지는 확인하지 못했습니다. 툴킷 기본 규칙 기준 배포 영향 감사는 거쳤습니다.

# Atomy Toolkit 0.7.0 — 긴 세션에서 느려지던 `/handoff`·`/rpi`·`/new` 를 가볍게

0.6.0 이후 달라진 점입니다. 이번 판은 속도와 분량을 줄이는 데 집중했습니다.

## 빨라진 점

- **`/handoff` 가 지금 대화 기록을 찾는 시간이 크게 줄었습니다.** 대화 기록이 많이 쌓인 기기, 특히 다른 기기에서 쓰던 프로젝트 경로가
  기록에 섞여 있는 기기에서 마감 한 번에 몇 분씩 걸리던 문제를 고쳤습니다. 기록 1,400여 개가 쌓인 기기에서 한 번 찾는 데 352초이던 것이
  0.4초가 됐습니다. 고르는 대화는 예전과 같습니다.
- **`/rpi`·`/new` 가 진행 상황을 작업번호별 파일로 보관합니다.** 예전에는 AI가 단계마다 진행 상황 쪽지를 통째로 다시 써서 보냈습니다.
  이제 작업번호와 방금 끝낸 단계의 근거 한 줄만 보냅니다. `/rpi` 한 단계에 AI가 쓰는 글이 약 3,100자에서 80자 남짓으로 줄었습니다.
  단계를 건너뛰지 못하게 막는 검사는 그대로입니다. 대화가 압축되거나 번호를 잊어도 진행 중인 작업 목록에서 이어갈 수 있습니다.
- **`/rpi` 가 돌려주는 글에서 되풀이를 뺐습니다.** 같은 "추가로 읽을 목록"을 단계마다 다시 싣지 않고, 안 바뀌는 항목은 바뀔 때만 싣습니다.

## 새 기능

- **`/new` 의 단계별 실행 카드.** 파일을 만드는 단계마다 정확한 명령·입력 형식·확인 방법을 함께 알려 줍니다. AI가 방법을 찾느라
  참고문서와 예전 프로젝트를 뒤지던 시간을 줄이기 위한 것입니다. 프로그램 개발 업무를 새로 만들 때만 나옵니다.
  설치가 프로젝트 폴더 밖의 도구 설정(MCP 서버 등록 등)도 바꾼다는 점은 제안 단계에서 함께 보여 주고 승인받습니다.
- **`/new` 가 질문을 한 화면에 모아 묻습니다.** 협업 방식·업무 종류·얽힘 여부를 따로따로 묻지 않습니다.
- **`/handoff` 가 끝나지 않은 `/rpi`·`/new` 작업을 알려 줍니다.** 끝난 작업의 기록은 마감 때 보관 폴더로 옮기고, 진행 중인 작업은
  다음 세션이 작업번호로 이어갈 수 있게 그대로 둡니다.

## 고친 점

- `/handoff` 에 세션 이름 대신 대화 번호를 넣었을 때, 무엇을 넣어야 하는지와 지금 열려 있는 세션 이름을 알려 줍니다.
- 맞는 대화 기록이 없을 때 후보 전체를 쏟아 내지 않고 최근 10개와 전체 수만 알립니다.
- 진행 상황 폴더(`.atomy/guided-runs/`)는 안에 제외 파일을 함께 만들어 공동 저장소에 담기지 않습니다.

## 올리는 순서

`/rpi`·`/new` 안내문이 바뀌었습니다. **프로그램을 먼저 올리고, 대화를 새로 연 뒤, 프로젝트에 안내문을 내려받으세요**(`atomy-toolkit cascade sync`).
한 프로젝트를 여러 기기에서 쓰면 모든 기기에서 프로그램을 먼저 올립니다. 순서가 어긋나 새 안내문이 옛 프로그램을 만나더라도
옛 방식으로 이어가도록 안내문에 적어 두었습니다. 동봉 지침은 1.2.9 입니다.

## 확인 범위와 알려진 한계

- 자동 검사는 Linux·macOS·Windows 에서 돌렸습니다. 열린 AI 앱에서의 실제 사용 시간이 얼마나 줄어드는지는 아직 재지 않았습니다.
  위 수치는 주고받는 글의 양과 도구 호출 시간입니다.
- `/new` 실행 카드는 프로그램 개발 업무의 새로 만들기에만 있습니다. 문서 업무, 기존 프로젝트 정비(`--upgrade`), 팀 연결 단계에는 없습니다.
- 카드의 확인 명령은 bash 기준입니다(Windows 는 Git Bash).

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

# Atomy Toolkit v0.4.0 — 패치 노트

[English](PATCH_NOTES.md) | 한국어

- **상태:** 발행
- **릴리스 날짜:** 2026-07-30
- **비교 기준:** 공개 `v0.3.1` (2026-06-15)
- **source commit:** `f321cc47045bec5c0b08f05163fec2e44bc408f4`

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
full-night 실행과 다음 날 검수를 완료했습니다. 다만 대기·백스톱 관련 설정값은 아직
잠정값이라 실측 데이터로 교체하는 일이 남아 있어, 검증 완료가 아니라 Preview로 둡니다.

## Experimental

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
| Source commit | `f321cc47045bec5c0b08f05163fec2e44bc408f4` |
| Cascade master metadata | `1.1.3` |
| 재현 가능한 wheel epoch | `SOURCE_DATE_EPOCH=1785391413` |
| `atomy_toolkit_lib-0.4.0-py3-none-any.whl` SHA256 | `bd90615f04c647a0d3e004ea75e65bb18bad3467a335316b0d9883c079c2043a` |
| `SHA256.txt` SHA256 | `563350acde38236dd788056df7045d426a52f56567ddc353ca0dd26825e1f08d` |
| `install-cli.sh` SHA256 | `c4509c51bc5cb18f3d0d33867477fc327976f19b889df5642aec76d9e6b7ffdc` |
| `install-cli.ps1` SHA256 | `0d96ad79157eddf03502958f9cc3d33aaa27d09f92b5d00cbb9a62dd1f606804` |

릴리스 검증은 위 source commit과 공개 asset 4개에 적용됩니다. 독립 다운로드 검증
절차는 [공개 설치 가이드](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md)를 참고하세요.
