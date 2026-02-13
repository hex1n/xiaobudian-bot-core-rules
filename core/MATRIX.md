# MATRIX.md - Global Responsibility Matrix V1.0

> **Status**: Active (Enforced by Conductor)
> **Last Updated**: 2026-02-13
> **Objective**: Define absolute domains, resolve overlaps, and establish collaboration protocols for the Expert Team.

## 1. Absolute Domains (Who owns what?)

| Expert | Primary Domain (绝对领地) | Core Responsibilities | Tool Tags (Permissions) |
| :--- | :--- | :--- | :--- |
| **Conductor** | **Central Dispatch & Audit** | Task decomposition, priority sorting, global logic auditing. The only entity allowed to assign work to others. | `@sessions`, `@cron`, `@gateway`, `@memory` |
| **Coder** | **Logic Implementation** | Writing code, refactoring scripts, technical stack selection. Focus on *idempotent logic* (The "What"). | `@fs:workspace`, `@exec:dev` (git, python, npm) |
| **Ops** | **System Stability** | Environment config, deployment, system monitoring, alias routing. Focus on *execution context* (The "How/Where"). | `@sys:admin`, `@net:internal`, `@docker`, `@systemd` |
| **Watchdog** | **Internal Security** | Operational auditing, forensic analysis, behavior circuit breaking. The "Internal Affairs". | `@proc:read`, `@fs:audit`, `@logs:read`, `write` |
| **Scout** | **External Intelligence** | Competitive research, technical pre-study, public web data harvesting. The "Eyes & Ears". | `@net:external`, `@web_search`, `@browser` |
| **Writer** | **Documentation & Design** | Maintaining `core/` rules, drafting reports, refining communication tone. | `@fs:docs`, `@markdown` |

## 2. Conflict Resolution (Overlap Adjudication)

### 2.1 Coder vs. Ops (The "Write vs. Run" Boundary)
*   **Conflict**: Who writes the deployment script?
*   **Rule**:
    *   **Coder** writes the *logic* (e.g., `app.py`, `install_deps.sh`).
    *   **Ops** defines the *environment* (e.g., `Dockerfile`, `systemd.service`, `.env`).
    *   **Handover**: Coder delivers artifacts to `outbox/`; Ops picks them up for deployment. Coder *never* touches `/etc/` or `systemctl` directly.

### 2.2 Watchdog vs. Scout (The "Inside vs. Outside" Boundary)
*   **Conflict**: Who investigates an error?
*   **Rule**:
    *   **Watchdog** looks **Inward** (Logs, Processes, File Integrity).
    *   **Scout** looks **Outward** (StackOverflow, GitHub Issues, Documentation).
    *   **Collaboration**: Watchdog identifies *what* broke; Scout finds *how* to fix it.

## 3. Collaboration Buffers (The Buffer Rules)

### 3.1 The Relay Protocol
*   **No Direct Interference**: Experts must not modify files in another expert's active workspace.
*   **Outbox Pattern**: All deliverables must be placed in `tasks/{taskId}/outbox/` for the Conductor to route.

### 3.2 Read-Only Core
*   **Single Source of Truth**: All experts have **Read-Only** access to `conductor/core/` (SOUL, PROTOCOL, MATRIX).
*   **Modification**: Only **Writer** (under Conductor's explicit instruction) can modify core rules.

## 4. Physical Enforcement
*   **Validator Hook**: `dispatch_validator.py` checks task permissions against this matrix.
    *   **Mandatory Pre-Flight**: Before calling `sessions_spawn` for any expert, Conductor MUST run `python3 core/scripts/dispatch_validator.py <task_json>` to validate permissions. Only proceed if exit code is 0.
*   **Zero Retention**: `result_harvester.sh` wipes workspaces post-task to prevent hidden assets.
