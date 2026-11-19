#!/usr/bin/env sh
set -eu

# Inputs: env override wins, else the values baked in at release time by
# `atomy-toolkit package bootstrap` (which replaces the __WHEEL_*__ tokens).
WHEEL_URL="${ATOMY_TOOLKIT_WHEEL_URL:-https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.8.0/atomy_toolkit_lib-0.8.0-py3-none-any.whl}"
WHEEL_SHA256="${ATOMY_TOOLKIT_WHEEL_SHA256:-b80af6110cc45b3e1f844e38f22edd870a008bdd2480a8cb93c4abe4cb857819}"
INSTALL_ROOT="${ATOMY_TOOLKIT_INSTALL_ROOT:-$HOME/atomy-toolkit}"
CODING_TOOL="${ATOMY_TOOLKIT_CODING_TOOL:-codex}"
IDE_TOOL="${ATOMY_TOOLKIT_IDE_TOOL:-skip}"

case "$WHEEL_URL" in
  __WHEEL_URL__ | "")
    echo "ERROR: wheel URL not set. Build a release bootstrap with" \
         "'atomy-toolkit package bootstrap', or set ATOMY_TOOLKIT_WHEEL_URL." >&2
    exit 1 ;;
esac
case "$WHEEL_SHA256" in
  __WHEEL_SHA256__ | "")
    echo "ERROR: wheel SHA256 not set (set ATOMY_TOOLKIT_WHEEL_SHA256)." >&2
    exit 1 ;;
esac

case "$CODING_TOOL:$IDE_TOOL" in
  codex:skip | codex:antigravity | skip:skip | skip:antigravity) ;;
  *) echo "지원하지 않는 설치 선택입니다: $CODING_TOOL / $IDE_TOOL" >&2; exit 1 ;;
esac

# 내려받기와 uv의 임시 Python은 사용자 설치 영역 밖에서 준비한다.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

py_ok() {
  command -v "$1" >/dev/null 2>&1 && \
    "$1" -c 'import sys; raise SystemExit(0 if sys.version_info[:2] >= (3, 12) else 1)' \
      >/dev/null 2>&1
}

# --- Resolve a Python >= 3.12. The wheel is ALWAYS installed into an isolated
#     venv ($INSTALL_ROOT/.runtimes/install-*) — never system-site / --user. This avoids PEP
#     668 (externally-managed-environment) failures and prevents a stale
#     ~/.local editable install from shadowing the toolkit (Issue A/B). ---
VENV_DIR="$TMP/python"
BASE_PY=""   # system interpreter that bootstraps the venv (USE_UV=0 path)
RUN_PY=""    # interpreter available NOW for the download/sha helpers
USE_UV=0
UV=""

python_install_help() {
  echo "Install Python 3.12+ from https://www.python.org/downloads/." >&2
  echo "Alternatively, install uv separately using its official instructions:" >&2
  echo "https://docs.astral.sh/uv/getting-started/installation/" >&2
  echo "Then ensure uv is on PATH or set ATOMY_TOOLKIT_UV_BIN, and rerun this installer." >&2
}

# --- Python 3.12+ 도 uv 도 없으면 묻지 않고 uv 를 받는다 (D-108, 2026-11-18 소유자 결정). ---
# 판을 고정하고, 받은 파일을 아래 확인값과 대조한 뒤에만 실행한다. 설치 스크립트를 받아 바로 실행하지
# 않는다(0.4.0 의 거부가 막던 것). 관리자 권한 없이 사용자 폴더(~/.local/bin)에 둔다 — 차단 훅이 그 자리를
# 직접 본다. 판·확인값을 바꿀 때는 install-cli.ps1 과 함께 바꾼다(시험이 두 파일을 대조한다).
UV_VERSION="0.13.7"
UV_HOME_BIN="$HOME/.local/bin/uv"

uv_target() {
  case "$(uname -s 2>/dev/null)-$(uname -m 2>/dev/null)" in
    Darwin-arm64 | Darwin-aarch64) echo "aarch64-apple-darwin" ;;
    Darwin-x86_64) echo "x86_64-apple-darwin" ;;
    Linux-x86_64 | Linux-amd64) echo "x86_64-unknown-linux-gnu" ;;
    Linux-aarch64 | Linux-arm64) echo "aarch64-unknown-linux-gnu" ;;
    *) echo "" ;;
  esac
}

uv_expected_sha() {
  case "$1" in
    aarch64-apple-darwin) echo "81b811b57e4624df7ed3aac148e0359100d9962f3d9dce00aec533dc2e086731" ;;
    x86_64-apple-darwin) echo "20c47e4c1f630b8abaff8c291fa9b9aa300fef92c4fbff95adf198b55287cda7" ;;
    x86_64-unknown-linux-gnu) echo "c5221ff41b7892bfc223543883600125f6a47fe845093e0f5bdff4f359196d83" ;;
    aarch64-unknown-linux-gnu) echo "71279f8d3c67241e807b9d8db872d1bf541579fb9f08b7d1eb1682196d1e57dc" ;;
    *) echo "" ;;
  esac
}

sha256_of() {
  if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  else echo ""; fi
}

uv_fail() {
  echo "ERROR: $1" >&2
  echo "Python 3.12 이상과 uv 가 없어 uv 를 자동으로 받으려 했지만 못 했습니다: $1" >&2
  echo "다음에 할 일: 아래 안내대로 Python 3.12 이상을 직접 설치한 뒤 이 설치 명령을 다시 실행하세요." >&2
  python_install_help
  exit 1
}

fetch_uv() {
  target="$(uv_target)"
  [ -n "$target" ] || uv_fail "this computer type ($(uname -s 2>/dev/null)-$(uname -m 2>/dev/null)) has no pinned uv checksum"
  expected="${ATOMY_TOOLKIT_UV_SHA256:-$(uv_expected_sha "$target")}"
  if [ -n "${ATOMY_TOOLKIT_UV_SHA256:-}" ] || [ -n "${ATOMY_TOOLKIT_UV_DOWNLOAD_BASE:-}" ]; then
    echo "WARNING: 설정값으로 uv 확인값 또는 받는 주소를 바꿨습니다 (ATOMY_TOOLKIT_UV_SHA256 / ATOMY_TOOLKIT_UV_DOWNLOAD_BASE)." >&2
  fi
  base="${ATOMY_TOOLKIT_UV_DOWNLOAD_BASE:-https://github.com/astral-sh/uv/releases/download/$UV_VERSION}"
  archive="$TMP/uv-$target.tar.gz"
  command -v curl >/dev/null 2>&1 || uv_fail "curl is not available to download uv"
  echo "Python 3.12 이상과 uv 가 없어 uv $UV_VERSION ($target) 을 받습니다: $base/uv-$target.tar.gz" >&2
  echo "  관리자 권한 없이 $UV_HOME_BIN 에 둡니다. 원래 있던 Python 은 건드리지 않습니다." >&2
  if ! curl -fsSL --connect-timeout 20 --max-time 600 -o "$archive" "$base/uv-$target.tar.gz"; then
    rm -f "$archive"
    uv_fail "uv download failed (network or company firewall may be blocking github.com)"
  fi
  actual="$(sha256_of "$archive")"
  if [ -z "$actual" ] || [ "$actual" != "$expected" ]; then
    rm -f "$archive"
    uv_fail "uv SHA256 mismatch. expected=$expected actual=${actual:-unavailable}"
  fi
  mkdir -p "$TMP/uv-extract" "$HOME/.local/bin"
  tar -xzf "$archive" -C "$TMP/uv-extract" || uv_fail "could not unpack the uv archive"
  [ -f "$TMP/uv-extract/uv-$target/uv" ] || uv_fail "uv archive has an unexpected layout"
  cp "$TMP/uv-extract/uv-$target/uv" "$UV_HOME_BIN.tmp.$$"
  chmod 755 "$UV_HOME_BIN.tmp.$$"
  mv -f "$UV_HOME_BIN.tmp.$$" "$UV_HOME_BIN"
  echo "받음: uv $UV_VERSION ($target, 확인값 일치) → $UV_HOME_BIN" >&2
}

if [ "${ATOMY_TOOLKIT_FORCE_UV:-0}" != "1" ]; then
  for cand in "${PYTHON:-}" python3 python; do
    if py_ok "$cand"; then BASE_PY="$(command -v "$cand")"; break; fi
  done
fi

if [ -n "$BASE_PY" ]; then
  RUN_PY="$BASE_PY"
  echo "Isolated venv target: $VENV_DIR (system Python $BASE_PY)" >&2
else
  if [ "${ATOMY_TOOLKIT_NO_UV:-0}" = "1" ]; then
    echo "ERROR: Python 3.12+ not found and uv provisioning is disabled." >&2
    python_install_help
    exit 1
  fi
  UV="${ATOMY_TOOLKIT_UV_BIN:-$(command -v uv 2>/dev/null || true)}"
  if [ -z "$UV" ] && [ -x "$UV_HOME_BIN" ]; then
    UV="$UV_HOME_BIN"
    echo "이미 받아 둔 uv 를 씁니다: $UV ($("$UV" --version 2>/dev/null || echo "판 확인 불가"))" >&2
  fi
  if [ -z "$UV" ]; then
    if [ "${ATOMY_TOOLKIT_DRY_RUN:-0}" = "1" ]; then
      echo "dry-run ok (python missing; would download uv $UV_VERSION to $UV_HOME_BIN)"
      exit 0
    fi
    fetch_uv
    UV="$UV_HOME_BIN"
  fi
  echo "Provisioning Python 3.12 via uv (venv: $VENV_DIR)..." >&2
  "$UV" venv --python 3.12 "$VENV_DIR"
  RUN_PY="$VENV_DIR/bin/python"
  USE_UV=1
  echo "마련함: Python $("$RUN_PY" -c 'import platform; print(platform.python_version())' 2>/dev/null || echo '?') (uv 가 받아 사용자 폴더에 둠, $("$UV" --version 2>/dev/null || echo uv))" >&2
fi

# --- Download the wheel (preserve its real PEP 427 filename) + verify SHA256. ---
WHEEL="$TMP/$(basename "${WHEEL_URL%%\?*}")"

"$RUN_PY" - "$WHEEL_URL" "$WHEEL" <<'PYEOF'
from __future__ import annotations

import os
import shutil
import sys
import urllib.request
from pathlib import Path
from urllib.parse import unquote, urlparse

url = sys.argv[1]
out = Path(sys.argv[2])
parsed = urlparse(url)
if parsed.scheme == "file":
    file_path = unquote(parsed.path)
    if os.name == "nt" and len(file_path) >= 4 and file_path[0] == "/" and file_path[2] == ":":
        file_path = file_path[1:]
    shutil.copy2(Path(file_path), out)
else:
    urllib.request.urlretrieve(url, out)
PYEOF

ACTUAL="$("$RUN_PY" - "$WHEEL" <<'PYEOF'
from __future__ import annotations

import hashlib
import sys
from pathlib import Path

print(hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest())
PYEOF
)"

if [ "$ACTUAL" != "$WHEEL_SHA256" ]; then
  echo "ERROR: wheel SHA256 mismatch. expected=$WHEEL_SHA256 actual=$ACTUAL" >&2
  exit 1
fi

if [ "${ATOMY_TOOLKIT_DRY_RUN:-0}" = "1" ]; then
  echo "dry-run ok (python resolved, sha verified, uv=$USE_UV)"
  exit 0
fi

# --- Install the wheel into the isolated venv. system-site / --user 금지. ---
# `[mcp]` extra 포함 — MCP server 는 toolkit 워크플로(/rpi 등)의 1순위 진입점이라
# 선택 부품이 아니다. 빠지면 슬래시 명령이 조용히 CLI fallback 으로만 돈다
# (2026-08-19 진단). pip·uv 모두 wheel 경로 뒤 extras 표기를 받는다 (실측).
# 실행 중인 옛 Python과 같은 버전의 옛 파일도 덮지 않는다.
mkdir -p "$INSTALL_ROOT/.runtimes"
VENV_DIR="$(mktemp -d "$INSTALL_ROOT/.runtimes/install-XXXXXXXX")"
VENV_PY="$VENV_DIR/bin/python"
WHEEL_WITH_EXTRAS="${WHEEL}[mcp]"
if [ "$USE_UV" = "1" ]; then
  "$UV" venv --python 3.12 "$VENV_DIR"
  "$UV" pip install --python "$VENV_PY" "$WHEEL_WITH_EXTRAS"
else
  "$BASE_PY" -m venv "$VENV_DIR"
  VENV_PY="$VENV_DIR/bin/python"
  "$VENV_PY" -m pip install --upgrade "pip>=26.1.2,<27"
  "$VENV_PY" -m pip install "$WHEEL_WITH_EXTRAS"
fi

# -P: cwd 를 sys.path 에 넣지 않는다. 설치기를 개발 저장소 안에서 실행해도
# 그곳의 atomy_toolkit/ 사본이 방금 설치한 wheel 을 가리지 못하게 한다.
"$VENV_PY" -P -m atomy_toolkit.cli self-install \
  --root "$INSTALL_ROOT" --coding-tool "$CODING_TOOL" --ide-tool "$IDE_TOOL"

# Warn if a stale 'atomy-toolkit' (e.g. an old --user editable) shadows the venv,
# then drop a stable shim into ~/.local/bin pointing at the venv entry point.
EXISTING="$(command -v atomy-toolkit 2>/dev/null || true)"
if [ -n "$EXISTING" ] && [ "$EXISTING" != "$VENV_DIR/bin/atomy-toolkit" ]; then
  echo "WARNING: existing 'atomy-toolkit' on PATH ($EXISTING) may shadow this install;" \
       "replacing the ~/.local/bin shim to point at the venv." >&2
fi
# 이 스위치의 뜻은 **Windows 쪽 동작이 정본**이다 (2026-08-15 소유자 결정):
# shim 은 언제나 만들고, 건너뛰는 것은 **영속 PATH 등록/안내**뿐이다.
# 이전에는 POSIX 만 shim 자체를 만들지 않아, 같은 이름의 스위치가 플랫폼마다 다른 것을
# 뜻했고 Linux 쪽 실패가 설치 시점이 아니라 뒤로 밀렸다 (2026-08-07 기록).
mkdir -p "$HOME/.local/bin"
# 기존 실행 연결도 고유 복구 위치에 보존한 뒤 원자적으로 바꾼다.
"$VENV_PY" - "$HOME/.local/bin/atomy-toolkit" "$VENV_DIR/bin/atomy-toolkit" "$INSTALL_ROOT" <<'PYEOF'
import os
import shutil
import sys
import tempfile
from pathlib import Path

shim, target, root = map(Path, sys.argv[1:])
if shim.exists() or shim.is_symlink():
    if shim.is_dir():
        raise SystemExit("실행 연결 위치가 폴더입니다. 기존 자료를 확인하세요.")
    backups = root / ".toolkit-install-backups"
    backups.mkdir(parents=True, exist_ok=True)
    backup = Path(tempfile.mkdtemp(prefix="command-", dir=backups))
    shutil.copy2(shim, backup / shim.name, follow_symlinks=False)
fd, temporary = tempfile.mkstemp(prefix=".atomy-toolkit-", dir=shim.parent)
os.close(fd)
try:
    os.unlink(temporary)
    os.symlink(target, temporary)
    os.replace(temporary, shim)
finally:
    if os.path.lexists(temporary):
        os.unlink(temporary)
PYEOF
if [ "${ATOMY_TOOLKIT_SKIP_PATH_UPDATE:-0}" = "1" ]; then
  echo "ATOMY_TOOLKIT_SKIP_PATH_UPDATE=1 - shim created; skipping persistent PATH setup." >&2
  echo "Shim: $HOME/.local/bin/atomy-toolkit (add that directory to PATH to use)." >&2
fi

echo "Done. Atomy Toolkit installed to $INSTALL_ROOT (venv: $VENV_DIR)" >&2
# shim 은 위에서 항상 만들었다. 스위치가 켜졌을 때는 그 사실을 이미 알렸으므로
# 여기서는 PATH 안내만 한 번 더 내지 않는다.
if [ "${ATOMY_TOOLKIT_SKIP_PATH_UPDATE:-0}" != "1" ]; then
  echo "Ensure \$HOME/.local/bin is on PATH (shim: $HOME/.local/bin/atomy-toolkit)." >&2
fi
# QOL #5 (2026-08-28): 설치 직후 "이제 뭐부터?" 다음 3단계 안내
echo "" >&2
echo "다음 3단계:" >&2
echo "  1) 프로젝트 폴더에서: atomy-toolkit install .   (작업 규칙 설치)" >&2
echo "  2) AI 도구에서 /rpi 를 입력해 첫 작업을 시작하세요" >&2
echo "  3) 막히면 /sos 에 오류를 붙여넣으세요 (쉬운 말 번역)" >&2

