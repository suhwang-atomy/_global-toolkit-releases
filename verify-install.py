"""앱 설정의 실행기로 초기 연결·필수 도구·읽기 호출을 확인한다."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tomllib
from pathlib import Path


def main() -> int:
    config = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))) / "config.toml"
    if "--probe" not in sys.argv:
        with config.open("rb") as stream:
            entry = tomllib.load(stream)["mcp_servers"]["atomy-toolkit-mcp"]
        return subprocess.run(
            [entry["command"], "-I", str(Path(__file__).resolve()), "--probe"],
            check=False, timeout=120,
        ).returncode

    from atomy_toolkit.mcp_runtime import inspect_mcp_config

    results = {}
    for name, path in {"codex": config, "claude": Path.home() / ".claude.json"}.items():
        result = inspect_mcp_config(path)
        module = Path(result.get("runtime", {}).get("module", ""))
        reference = Path(result.get("read_call", {}).get("reference_path", ""))
        result["installed_source_verified"] = all(
            Path(sys.prefix).resolve() in source.resolve().parents
            for source in (module, reference)
        )
        results[name] = result
    print(json.dumps(results, indent=2, ensure_ascii=False))
    return 0 if all(
        result.get("status") == "ok" and result["installed_source_verified"]
        for result in results.values()
    ) else 1


if __name__ == "__main__":
    raise SystemExit(main())
