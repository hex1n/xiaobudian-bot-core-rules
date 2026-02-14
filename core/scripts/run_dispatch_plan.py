#!/usr/bin/env python3
"""run_dispatch_plan.py

A single, auditable entrypoint for Team Mode dispatch.

It enforces:
- Orchestrator-only (Conductor does not execute)
- Mandatory Watchdog verifier (strong mode)
- Tool-domain validation via dispatch_validator.py for every assignee
- Team-mode preflight via preflight_team_mode.py

This script is intentionally non-magical: it only validates and prints what to run next.
(Actual spawn/execution happens in the Conductor runtime after gates pass.)

Usage:
  python3 core/scripts/run_dispatch_plan.py path/to/dispatch_plan.json

Dispatch plan schema: see templates/DISPATCH_PLAN.json
"""

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Tuple

ROOT = Path(__file__).resolve().parents[2]
PREFLIGHT = ROOT / "core/scripts/preflight_team_mode.py"
VALIDATOR = ROOT / "core/scripts/dispatch_validator.py"


def sh(cmd: List[str]) -> Tuple[int, str]:
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    return p.returncode, p.stdout.strip()


def die(msg: str, code: int = 2) -> None:
    print("Status: REJECTED")
    print(f"Reason: {msg}")
    sys.exit(code)


def ok(msg: str) -> None:
    print("Status: APPROVED")
    print(f"Reason: {msg}")
    sys.exit(0)


def load_json(path: Path) -> Dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def main(argv: List[str]) -> None:
    if len(argv) != 2:
        die("Usage: run_dispatch_plan.py <dispatch_plan.json>")

    plan_path = Path(argv[1]).expanduser()
    if not plan_path.exists():
        die(f"Plan file not found: {plan_path}")

    plan = load_json(plan_path)

    task_id = (plan.get("task_id") or "").strip()
    risk_level = (plan.get("risk_level") or "").lower().strip()
    executors = plan.get("executors") or []
    verifier = (plan.get("verifier") or "").strip()
    exception_reason = (plan.get("exception_reason") or "").strip()
    tasks = plan.get("tasks") or {}

    if not task_id:
        die("Missing task_id")

    # 1) Team-mode preflight
    preflight_payload = {
        "task_id": task_id,
        "risk_level": risk_level,
        "executors": executors,
        "verifier": verifier,
        "exception_reason": exception_reason,
    }

    tmp = Path("/tmp") / f"dispatch_plan_preflight_{os.getpid()}.json"
    tmp.write_text(json.dumps(preflight_payload, ensure_ascii=False, indent=2), encoding="utf-8")

    code, out = sh([sys.executable, str(PREFLIGHT), str(tmp)])
    if code != 0:
        print(out)
        die("Preflight failed")

    # 2) Tool-domain validation for every assignee listed in tasks
    if not isinstance(tasks, dict) or not tasks:
        die("tasks must be a non-empty mapping of assignee -> task_json_path")

    failures = []
    approvals = []

    for assignee, task_json in tasks.items():
        task_path = (ROOT / task_json).resolve() if not str(task_json).startswith("/") else Path(task_json)
        if not task_path.exists():
            failures.append(f"Task JSON missing for {assignee}: {task_path}")
            continue
        code, out = sh([sys.executable, str(VALIDATOR), str(task_path)])
        if code != 0:
            failures.append(f"{assignee}: {out}")
        else:
            approvals.append(f"{assignee}: {out.splitlines()[-1] if out else 'APPROVED'}")

    if failures:
        print("Status: REJECTED")
        print("Reason: One or more task tool validations failed")
        for f in failures:
            print(f"- {f}")
        sys.exit(3)

    print("Status: APPROVED")
    print(f"Reason: Dispatch plan validated for task_id={task_id}")
    print("Approvals:")
    for a in approvals:
        print(f"- {a}")

    print("\nNext step (manual): spawn executors + verifier, collect returns, then write ship/DECISION.md")
    sys.exit(0)


if __name__ == "__main__":
    main(sys.argv)
