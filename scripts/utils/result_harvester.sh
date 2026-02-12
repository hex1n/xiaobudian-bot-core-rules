#!/bin/bash
# result_harvester.sh - 自动化成果收割脚本
TASK_ID=$1
FINDINGS=$2
OUTBOX="/root/.openclaw/workspaces/main/tasks/${TASK_ID}/outbox"
REPORT="${OUTBOX}/final_report.md"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <TASK_ID> <FINDINGS>"
  exit 1
fi

mkdir -p "$OUTBOX"
echo -e "# Final Report for ${TASK_ID}\n\n## Summary of Findings\n${FINDINGS}\n\n---\n*Harvested at: $(date)*" > "$REPORT"
echo "Findings successfully harvested to ${REPORT}"
