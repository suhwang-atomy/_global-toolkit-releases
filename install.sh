#!/usr/bin/env sh
set -eu

# Inputs: an explicit environment override wins; otherwise use the pinned
# public v0.4.0 wheel and its release checksum.
WHEEL_URL="${ATOMY_TOOLKIT_WHEEL_URL:-https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.0/atomy_toolkit_lib-0.4.0-py3-none-any.whl}"
WHEEL_SHA256="${ATOMY_TOOLKIT_WHEEL_SHA256:-6a9097f2be443192db66fa5f038b435b391549760641878db109525330321297}"
INSTALL_ROOT="${ATOMY_TOOLKIT_INSTALL_ROOT:-$HOME/atomy-toolkit}"
CODING_TOOL="${ATOMY_TOOLKIT_CODING_TOOL:-codex}"
IDE_TOOL="${ATOMY_TOOLKIT_IDE_TOOL:-skip}"

if [ -z "$WHEEL_URL" ]; then
  echo "ERROR: wheel URL not set (set ATOMY_TOOLKIT_WHEEL_URL)." >&2
  exit 1
fi
if [ "${#WHEEL_SHA256}" -ne 64 ]; then
  echo "ERROR: wheel SHA256 must contain exactly 64 hexadecimal characters." >&2
  exit 1
fi
case "$WHEEL_SHA256" in
  *[!0-9a-fA-F]*)
    echo "ERROR: wheel SHA256 must contain only hexadecimal characters." >&2
    exit 1 ;;
esac

py_ok() {
  command -v "$1" >/dev/null 2>&1 && \
    "$1" -c 'import sys; raise SystemExit(0 if sys.version_info[:2] >= (3, 12) else 1)' \
      >/dev/null 2>&1
}

# --- Resolve a Python >= 3.12. The wheel is ALWAYS installed into an isolated
#     venv ($INSTALL_ROOT/.venv) — never system-site / --user. This avoids PEP
#     668 (externally-managed-environment) failures and prevents a stale
#     ~/.local editable install from shadowing the toolkit (Issue A/B). ---
VENV_DIR="$INSTALL_ROOT/.venv"
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

if [ "${ATOMY_TOOLKIT_FORCE_UV:-0}" != "1" ]; then
  for cand in ${PYTHON:-} python3 python; do
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
  if [ -z "$UV" ]; then
    echo "ERROR: Python 3.12+ not found and uv is not installed; refusing unverified automatic provisioning." >&2
    python_install_help
    exit 1
  fi
  echo "Provisioning Python 3.12 via uv (venv: $VENV_DIR)..." >&2
  "$UV" venv --python 3.12 "$VENV_DIR"
  RUN_PY="$VENV_DIR/bin/python"
  USE_UV=1
fi

# --- Download the wheel (preserve its real PEP 427 filename) + verify SHA256. ---
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
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
if [ "$USE_UV" = "1" ]; then
  "$UV" pip install --python "$RUN_PY" "$WHEEL"
  VENV_PY="$RUN_PY"
else
  "$BASE_PY" -m venv "$VENV_DIR"
  VENV_PY="$VENV_DIR/bin/python"
  "$VENV_PY" -m pip install --upgrade "pip>=26.1.2,<27"
  "$VENV_PY" -m pip install "$WHEEL"
fi

# Warn if a stale 'atomy-toolkit' (e.g. an old --user editable) shadows the venv,
# then drop a stable shim into ~/.local/bin pointing at the venv entry point.
EXISTING="$(command -v atomy-toolkit 2>/dev/null || true)"
if [ -n "$EXISTING" ] && [ "$EXISTING" != "$VENV_DIR/bin/atomy-toolkit" ]; then
  echo "WARNING: existing 'atomy-toolkit' on PATH ($EXISTING) may shadow this install;" \
       "replacing the ~/.local/bin shim to point at the venv." >&2
fi
mkdir -p "$HOME/.local/bin"
ln -sf "$VENV_DIR/bin/atomy-toolkit" "$HOME/.local/bin/atomy-toolkit"

"$VENV_PY" -m atomy_toolkit.cli self-install \
  --root "$INSTALL_ROOT" --coding-tool "$CODING_TOOL" --ide-tool "$IDE_TOOL"
echo "Done. Atomy Toolkit installed to $INSTALL_ROOT (venv: $VENV_DIR)" >&2
echo "Ensure \$HOME/.local/bin is on PATH (shim: $HOME/.local/bin/atomy-toolkit)." >&2
