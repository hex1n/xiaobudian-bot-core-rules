---
name: task-orchestrator
description: Manage complex, multi-agent tasks using a file-system bus (Inbox/Outbox pattern). Use for any task requiring multiple steps, parallel execution, or large context management.
---

# Task Orchestrator (Agent-Orchestrator Pattern)

This skill enables the **Dispatcher** (you) to manage **Specialist Sub-agents** via a robust file-system interface, decoupling execution from conversation history.

## Workflow

### 1. Initialize Task Workspace

When a complex request arrives:
1.  Generate a **Task ID**: `task_<timestamp>_<short_desc>` (e.g., `task_1703275200_research_ai`).
2.  Create the directory structure:
    ```bash
    mkdir -p tasks/<task_id>/{inbox,outbox}
    echo '{"status": "pending", "progress": 0}' > tasks/<task_id>/status.json
    ```

### 2. Prepare Context (Inbox)

Write all necessary instructions and context to `tasks/<task_id>/inbox/INSTRUCTIONS.md`.
*   **Goal**: Clear definition of done.
*   **Role**: Specific persona (eout/Writer/Ops).
*   **Constraints**: "Do not halluncinate", "Check X first".

### 3. Dispatch (Spawn)

Call `sessions_spawn` with a prompt that directs the Sub-agent to the workspace:

**Sub-Agent Prompt Template:**
```text
You are a Specialist Sub-agent (Role: <Role>).
Your workspace is: `tasks/<task_id>/`

**INSTRUCTIONS:**
1. Read `inbox/INSTRUCTIONS.md` for your task details.
2. Update `status.json` to `{"status": "running", "progress": 10}`.
3. Perform the task.
4. Write your FINAL output to `outbox/RESULT.md`.
5. Update `status.json` to `{"status": "done", "progress": 100}`.
6. Reply with ONLY: "TASK_DONE"
```

### 4. Monitor & Aggregate

Since `sessions_spawn` runs in the background:
1.  You (Dispatcher) can periodically check `tasks/<task_id>/status.json`.
2.  When `status` is `done`:
    *   Read `outbox/RESULT.md`.
    *   Validate the output against `inbox/INSTRUCTIONS.md`.
    *   If valid: Summarize and report to 0x01.
    *   If invalid: Write feedback to `inbox/FEEDBACK.md` and re-spawn (or ask 0x01 for help).

## Cleanup

Once the task is fully complete and reported:
- Archive the task folder (e.g., move to `archive/`) or delete if ephemeral.
- Default: Keep for 24h for audit, then delete.
