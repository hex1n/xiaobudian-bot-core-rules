#!/bin/bash

# Workspace Zero Retention Protocol: Result Harvester
# Purpose: Clean up ephemeral data and harvest important artifacts.

set -e

# Configuration
CENTRAL_LOG="/root/.openclaw/workspaces/conductor/logs/harvester.log"
DISPATCHER_OUTBOX="/root/.openclaw/workspaces/conductor/outbox"
DISPATCHER_MEMORY="/root/.openclaw/workspaces/conductor/memory"

# Protected patterns (do not delete)
PROTECTED_PATTERNS=(
    ".git"
    ".openclaw"
    "PROMPT.md"
    "SKILL.md"
    "AGENTS.md"
    "USER.md"
    "TOOLS.md"
    "MEMORY.md"
    "SOUL.md"
    "PROTOCOL.md"
    "MATRIX.md"
    "TEAM.md"
    "HEARTBEAT.md"
    "IDENTITY.md"
    "core"
)

# Usage info
usage() {
    echo "Usage: $0 <workspace_path> [--dry-run] [--auto-move]"
    echo "  <workspace_path>  Path to the workspace to harvest/clean."
    echo "  --dry-run         Show what would be done without making changes."
    echo "  --auto-move       Automatically move predefined artifacts to conductor outbox."
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

TARGET_WS=$(realpath "$1")
DRY_RUN=false
AUTO_MOVE=false

shift
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true ;;
        --auto-move) AUTO_MOVE=true ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

if [ ! -d "$TARGET_WS" ]; then
    echo "Error: Target workspace $TARGET_WS does not exist."
    exit 1
fi

log_action() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [WS: $TARGET_WS] $1"
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN LOG] $msg"
    else
        mkdir -p "$(dirname "$CENTRAL_LOG")"
        echo "$msg" >> "$CENTRAL_LOG"
    fi
}

echo "--- Harvesting results from $TARGET_WS ---"
[ "$DRY_RUN" = true ] && echo "!!! DRY RUN MODE ENABLED !!!"

# 1. Artifact Harvesting
# Patterns to harvest: final_report.md, core/scripts/*.py, etc.
harvest_patterns=(
    "final_report.md"
    "core/scripts/*.py"
    "reports/*.pdf"
    "results/*"
)

mkdir -p "$DISPATCHER_OUTBOX"

for pattern in "${harvest_patterns[@]}"; do
    # Find files matching the pattern within TARGET_WS, excluding protected dirs
    # Use find to be safer with wildcards
    find "$TARGET_WS" -path "$TARGET_WS/.git" -prune -o -path "$TARGET_WS/.openclaw" -prune -o -wholename "$TARGET_WS/$pattern" -type f -print | while read -r file; do
        rel_path="${file#$TARGET_WS/}"
        if [ "$AUTO_MOVE" = true ]; then
            echo "Moving artifact: $rel_path"
            if [ "$DRY_RUN" = false ]; then
                mkdir -p "$(dirname "$DISPATCHER_OUTBOX/$rel_path")"
                mv "$file" "$DISPATCHER_OUTBOX/$rel_path"
                log_action "Moved artifact $rel_path to outbox"
            else
                echo "[DRY-RUN] mv $file $DISPATCHER_OUTBOX/$rel_path"
            fi
        else
            echo "Detected artifact: $rel_path (Use --auto-move to harvest)"
        fi
    done
done

# 2. Cleanup
echo "--- Cleaning ephemeral files and untracked changes ---"

is_protected() {
    local item="$1"
    for p in "${PROTECTED_PATTERNS[@]}"; do
        if [[ "$item" == "$p" ]]; then
            return 0
        fi
    done
    return 1
}

# Check if it's a git repo
if [ -d "$TARGET_WS/.git" ]; then
    echo "Git repository detected. Using git clean..."
    # Prepare exclude args for protected files
    GIT_EXCLUDE=()
    for p in "${PROTECTED_PATTERNS[@]}"; do
        GIT_EXCLUDE+=("-e" "$p")
    done

    if [ "$DRY_RUN" = true ]; then
        git -C "$TARGET_WS" clean -fdn "${GIT_EXCLUDE[@]}"
        git -C "$TARGET_WS" checkout . 2>/dev/null || echo "[DRY-RUN] No tracked files to reset"
        echo "[DRY-RUN] git -C $TARGET_WS clean -fd ${GIT_EXCLUDE[@]}"
    else
        # Force remove untracked files/dirs
        git -C "$TARGET_WS" clean -fd "${GIT_EXCLUDE[@]}"
        # Restore modified tracked files
        git -C "$TARGET_WS" checkout . 2>/dev/null || true
        log_action "Wiped untracked files and reset tracked files via git"
    fi
else
    echo "Non-git directory. Manual wipe of unprotected items..."
    ls -A "$TARGET_WS" | while read -r item; do
        if is_protected "$item"; then
            echo "Skipping protected: $item"
        else
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY-RUN] rm -rf $TARGET_WS/$item"
            else
                rm -rf "$TARGET_WS/$item"
                log_action "Deleted $item"
            fi
        fi
    done
fi

echo "--- Harvest and Clean Complete ---"
