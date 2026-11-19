# Atomy Toolkit 0.8.0 설치 안내

이 안내와 설치 파일은 `release-manifest.json`에서 함께 생성했습니다.
Python 3.12 이상이 없어도 됩니다. Python 3.12 이상도 uv도 없으면 설치 파일이 묻지 않고
판을 고정한 uv를 받아 확인값을 대조한 뒤, 그 uv로 Python 3.12를 사용자 폴더에 마련합니다.
관리자 권한은 필요 없고 원래 있던 Python은 건드리지 않습니다. 받은 것과 판은 화면에 한 줄씩 남습니다.
받지 않게 하려면 `ATOMY_TOOLKIT_NO_UV=1`을 설정하고 Python 3.12 이상을 직접 설치하세요.
설치 파일을 내려받고 내용이 일치하는지 확인한 뒤 실행하세요.

## Linux

```sh
curl -fL -o install-cli.sh 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/install-cli.sh'
echo 'a21641f18879f0160d8153381d61b1f5d961f6034127b25d29420da0828ddccb  install-cli.sh' | sha256sum -c - && sh ./install-cli.sh
```

## macOS

```sh
curl -fL -o install-cli.sh 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/install-cli.sh'
echo 'a21641f18879f0160d8153381d61b1f5d961f6034127b25d29420da0828ddccb  install-cli.sh' | shasum -a 256 -c - && sh ./install-cli.sh
```

## Windows PowerShell

```powershell
Invoke-WebRequest -Uri 'https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/install-cli.ps1' -OutFile install-cli.ps1
if ((Get-FileHash ./install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant() -ne '5bc0e0d579c5363cf311e8601f5f5fb6a5815cf03fb9b71e0e8fe542884b8072') { throw '설치 파일 내용이 다릅니다.' }
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

- 버전: `0.8.0`
- 파일: `atomy_toolkit_lib-0.8.0-py3-none-any.whl`
- 주소: https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/atomy_toolkit_lib-0.8.0-py3-none-any.whl
- 내용 확인값(SHA256): `b80af6110cc45b3e1f844e38f22edd870a008bdd2480a8cb93c4abe4cb857819`
- 설치 파일의 확인값과 앱 선택 목록: `release-manifest.json`

공개 저장소의 README·상세 안내·루트 설치 파일을 갱신할 때는 같은 배포의
`public-source.zip`을 사용하세요. 이 파일 생성만으로 원격 공개 배포가 실행되지는 않습니다.
