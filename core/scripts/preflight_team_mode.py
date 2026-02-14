#!/usr/bin/env python3
"""preflight_team_mode.py

Hard gate for "Team Mode" dispatch.

This is intentionally simple and auditable: it validates a planned dispatch JSON
before any expert is spawned.

Usage:
  python3 core/scripts/preflight_team_mode.py path/to/dispatch_plan.json

Expected JSON schema (minimal):
{
  "task_id": "...",
  "risk_level": "low|medium|high",
  "executors": ["Scout", "Writer"],
  "verifier": "Watchdog",
  "exception_reason": "..."  // optional
}

Rules (strong mode):
- Must have at least 1 executor
- Must have verifier == "Watchdog"
- Exceptions allowed only if exception_reason is present AND risk_level == "low"
"""

import json
import sys
from typing import Any, Dict, List


def reject(msg: str, code: int = 2) -> None:
    print("Status: REJECTED")
    print(f"Reason: {msg}")
    sys.exit(code)


def approve(msg: str) -> None:
    print("Status: APPROVED")
    print(f"Reason: {msg}")
    sys.exit(0)


def load_json(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def main(argv: List[str]) -> None:
    if len(argv) != 2:
        reject("Usage: preflight_team_mode.py <dispatch_plan.json>", 2)

    plan_path = argv[1]
    try:
        plan = load_json(plan_path)
    except Exception as e:
        reject(f"Failed to load plan file: {e}")

    task_id = plan.get("task_id")
    risk = (plan.get("risk_level") or "").lower().strip()
    executors = plan.get("executors") or []
    verifier = (plan.get("verifier") or "").strip()
    exception_reason = (plan.get("exception_reason") or "").strip()

    if not task_id:
        reject("Missing task_id")

    if risk not in {"low", "medium", "high"}:
        reject("risk_level must be one of: low|medium|high")

    if not isinstance(executors, list) or not all(isinstance(x, str) and x.strip() for x in executors):
        reject("executors must be a non-empty list of expert names")

    if len(executors) < 1:
        reject("Team Mode requires at least 1 executor")

    # Strong-mode verifier requirement
    if verifier != "Watchdog":
        # Allow exception only for low-risk with explicit exception_reason
        if not (risk == "low" and exception_reason):
            reject("Verifier must be Watchdog (or provide exception_reason for low-risk only)")

    # Prevent Conductor-as-executor pattern explicitly
    if any(x.strip() == "Conductor" for x in executors):
        reject("Conductor cannot be listed as executor (orchestrator-only)")

    approve(f"Plan OK for task_id={task_id}: executors={executors}, verifier={verifier or 'N/A'}")


if __name__ == "__main__":
    main(sys.argv)
