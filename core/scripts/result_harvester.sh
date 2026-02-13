#!/bin/bash
# result_harvester.sh - V2.1 零留存收割脚本
TASK_ID=$1
FINDINGS=$2
WORKSPACE_ROOT="/root/.openclaw/workspaces"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <TASK_ID> <FINDINGS>"
  exit 1
fi

# 1. 成果落盘 (基于 Conductor 路径)
OUTBOX="${WORKSPACE_ROOT}/conductor/tasks/${TASK_ID}/outbox"
REPORT="${OUTBOX}/final_report.md"
mkdir -p "$OUTBOX"
echo -e "# Final Report for ${TASK_ID}\n\n## Summary of Findings\n${FINDINGS}\n\n---\n*Harvested at: $(date)*" > "$REPORT"

# 2. 零留存清扫 (执行专家工作区重置)
WHITELIST=("SOUL.md" "PROTOCOL.md" "MATRIX.md" "TEAM.md" "AGENTS.md" "USER.md" "TOOLS.md" "IDENTITY.md" "HEARTBEAT.md" "core" "docs" "memory" "scripts" "teams_rules")

for EXPERT in coder ops scout watchdog writer; do
    EXPERT_DIR="${WORKSPACE_ROOT}/${EXPERT}"
    if [ -d "$EXPERT_DIR" ]; then
        echo "Cleaning $EXPERT_DIR..."
        cd "$EXPERT_DIR"
        find . -maxdepth 1 -not -name "." $(printf "! -name %s " "${WHITELIST[@]}") -exec rm -rf {} +
    fi
done

echo "Harvesting and Zero-Retention sweep complete."
