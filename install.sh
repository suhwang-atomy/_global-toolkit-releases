#!/usr/bin/env sh
set -eu

RELEASE_REPO="${ATOMY_TOOLKIT_RELEASE_REPO:-suhwang-atomy/_global-toolkit-releases}"
INSTALL_ROOT="${ATOMY_TOOLKIT_INSTALL_ROOT:-$HOME/atomy-toolkit}"
CODING_TOOL="${ATOMY_TOOLKIT_CODING_TOOL:-codex}"
IDE_TOOL="${ATOMY_TOOLKIT_IDE_TOOL:-skip}"

python_ok() {
  "$1" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 12) else 1)' >/dev/null 2>&1
}

find_python() {
  if [ -n "${PYTHON:-}" ] && python_ok "$PYTHON"; then
    printf '%s\n' "$PYTHON"
    return 0
  fi
  for candidate in python3 python; do
    if command -v "$candidate" >/dev/null 2>&1 && python_ok "$candidate"; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

install_uv_python() {
  if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: Python 3.12+ not found, and curl is required to install uv." >&2
    exit 1
  fi
  if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv to provision Python 3.12..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
  UV_BIN="$(command -v uv || true)"
  if [ -z "$UV_BIN" ] && [ -x "$HOME/.local/bin/uv" ]; then
    UV_BIN="$HOME/.local/bin/uv"
  fi
  if [ -z "$UV_BIN" ]; then
    echo "ERROR: uv installation finished but uv was not found." >&2
    exit 1
  fi
  "$UV_BIN" python install 3.12
  "$UV_BIN" python find 3.12
}

PY="$(find_python || install_uv_python)"
if ! python_ok "$PY"; then
  echo "ERROR: Python 3.12+ required." >&2
  exit 1
fi

if [ -z "${ATOMY_TOOLKIT_WHEEL_URL:-}" ] || [ -z "${ATOMY_TOOLKIT_WHEEL_SHA256:-}" ]; then
  RELEASE_JSON_URL="https://api.github.com/repos/$RELEASE_REPO/releases/latest"
  ASSETS="$("$PY" - "$RELEASE_JSON_URL" <<'PYEOF'
from __future__ import annotations

import json
import sys
import urllib.request

url = sys.argv[1]
with urllib.request.urlopen(url, timeout=30) as response:
    data = json.load(response)
assets = data.get("assets", [])
wheel = next(
    (
        item["browser_download_url"]
        for item in assets
        if item.get("name", "").startswith("atomy_toolkit_lib-")
        and item.get("name", "").endswith(".whl")
    ),
    None,
)
sha = next(
    (
        item["browser_download_url"]
        for item in assets
        if item.get("name") in {"SHA256.txt", "SHA256SUMS.txt"}
    ),
    None,
)
if not wheel or not sha:
    raise SystemExit("latest release is missing atomy_toolkit_lib wheel or SHA256 asset")
print(wheel)
print(sha)
PYEOF
)"
  ATOMY_TOOLKIT_WHEEL_URL="$(printf '%s\n' "$ASSETS" | sed -n '1p')"
  SHA_URL="$(printf '%s\n' "$ASSETS" | sed -n '2p')"
  WHEEL_NAME="$(basename "${ATOMY_TOOLKIT_WHEEL_URL%%\?*}")"
  ATOMY_TOOLKIT_WHEEL_SHA256="$("$PY" - "$SHA_URL" "$WHEEL_NAME" <<'PYEOF'
from __future__ import annotations

import re
import sys
import urllib.request

with urllib.request.urlopen(sys.argv[1], timeout=30) as response:
    text = response.read().decode("utf-8", errors="replace")
wheel_name = sys.argv[2]
for line in text.splitlines():
    if wheel_name in line:
        match = re.search(r"\b[0-9a-fA-F]{64}\b", line)
        if match:
            print(match.group(0).lower())
            raise SystemExit(0)
hashes = re.findall(r"\b[0-9a-fA-F]{64}\b", text)
if len(hashes) == 1:
    print(hashes[0].lower())
    raise SystemExit(0)
raise SystemExit(f"SHA256 asset does not contain a unique hash for {wheel_name}")
PYEOF
)"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
WHEEL="$TMP/$(basename "${ATOMY_TOOLKIT_WHEEL_URL%%\?*}")"

"$PY" - "$ATOMY_TOOLKIT_WHEEL_URL" "$WHEEL" <<'PYEOF'
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

ACTUAL="$("$PY" - "$WHEEL" <<'PYEOF'
from __future__ import annotations

import hashlib
import sys
from pathlib import Path

print(hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest())
PYEOF
)"

EXPECTED="$(printf '%s' "$ATOMY_TOOLKIT_WHEEL_SHA256" | tr 'A-F' 'a-f')"
if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "ERROR: wheel SHA256 mismatch. expected=$EXPECTED actual=$ACTUAL" >&2
  exit 1
fi

if [ "${ATOMY_TOOLKIT_DRY_RUN:-0}" = "1" ]; then
  echo "dry-run ok (python=$PY, sha verified)"
  exit 0
fi

"$PY" -m pip --version >/dev/null 2>&1 || "$PY" -m ensurepip --upgrade
"$PY" -m pip install --user "$WHEEL"
"$PY" -m atomy_toolkit.cli self-install --root "$INSTALL_ROOT" --coding-tool "$CODING_TOOL" --ide-tool "$IDE_TOOL"
echo "Done. Atomy Toolkit installed to $INSTALL_ROOT"
