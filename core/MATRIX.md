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

## 2. Tool Tag Definitions (Permission Expansion)

| Tag | Allowed Tools | Description |
| :--- | :--- | :--- |
| `@sessions` | `browser`, `message`, `canvas`, `nodes`, `process` | Interaction with user sessions & UI |
| `@cron` | `exec`, `write`, `read` | Scheduled tasks & maintenance |
| `@gateway` | `exec` | Gateway daemon control |
| `@memory` | `read`, `write`, `edit`, `web_search` | Memory retrieval & storage |
| `@fs:workspace` | `read`, `write`, `edit`, `exec` | Workspace file operations |
| `@exec:dev` | `exec`, `read`, `write` | Development execution (git, python, npm) |
| `@sys:admin` | `exec` | System administration commands |
| `@net:internal` | `exec`, `web_fetch` | Internal network access |
| `@docker` | `exec` | Docker container management |
| `@systemd` | `exec` | Systemd service management |
| `@proc:read` | `exec`, `process` | Process state inspection |
| `@fs:audit` | `read`, `exec` | Audit logs access |
| `@logs:read` | `read`, `exec` | System logs reading |
| `@net:external` | `web_search`, `web_fetch`, `browser` | External internet access |
| `@web_search` | `web_search` | Web search capability |
| `@browser` | `browser` | Browser automation |
| `@fs:docs` | `read`, `write`, `edit` | Documentation file access |
| `@markdown` | `read`, `write`, `edit` | Markdown processing |

## 3. Conflict Resolution (Overlap Adjudication)

### 3.1 Coder vs. Ops (The "Write vs. Run" Boundary)
*   **Conflict**: Who writes the deployment script?
*   **Rule**:
    *   **Coder** writes the *logic* (e.g., `app.py`, `install_deps.sh`).
    *   **Ops** defines the *environment* (e.g., `Dockerfile`, `systemd.service`, `.env`).
    *   **Handover**: Coder delivers artifacts to `outbox/`; Ops picks them up for deployment. Coder *never* touches `/etc/` or `systemctl` directly.

### 3.2 Watchdog vs. Scout (The "Inside vs. Outside" Boundary)
*   **Conflict**: Who investigates an error?
*   **Rule**:
    *   **Watchdog** looks **Inward** (Logs, Processes, File Integrity).
    *   **Scout** looks **Outward** (StackOverflow, GitHub Issues, Documentation).
    *   **Collaboration**: Watchdog identifies *what* broke; Scout finds *how* to fix it.

## 4. Collaboration Buffers (The Buffer Rules)

### 4.1 The Relay Protocol
*   **No Direct Interference**: Experts must not modify files in another expert's active workspace.
*   **Outbox Pattern**: All deliverables must be placed in `tasks/{taskId}/outbox/` for the Conductor to route.

### 4.2 Read-Only Core
*   **Single Source of Truth**: All experts have **Read-Only** access to `conductor/core/` (SOUL, PROTOCOL, MATRIX).
*   **Modification**: Only **Writer** (under Conductor's explicit instruction) can modify core rules.

## 5. Physical Enforcement
*   **Validator Hook**: `dispatch_validator.py` checks task permissions against this matrix.
    *   **Mandatory Pre-Flight**: Before calling `sessions_spawn` for any expert, Conductor MUST run `python3 core/scripts/dispatch_validator.py <task_json>` to validate permissions. Only proceed if exit code is 0.
*   **Zero Retention**: `result_harvester.sh` wipes workspaces post-task to prevent hidden assets.
