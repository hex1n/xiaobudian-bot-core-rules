#!/bin/bash

# context_injector.sh
# 1. Generate file tree of task dir.
# 2. Tail last 3 lines of dispatcher_status_log.md.
# 3. Summarize meta.json.
# 4. Output to env_context.json.

TASK_DIR=$(pwd)
OUTPUT_FILE="env_context.json"

echo "Injecting context from $TASK_DIR..."

# 1. Generate file tree
FILE_TREE=$(find . -maxdepth 2 -not -path '*/.*' | sed -e 's/[^-][^\/]*\// |/g' -e 's/|/  /g' -e 's/  -/  |/')

# 2. Tail last 3 lines of dispatcher_status_log.md
if [ -f "dispatcher_status_log.md" ]; then
    LOG_TAIL=$(tail -n 3 dispatcher_status_log.md)
else
    LOG_TAIL="Log file not found."
fi

# 3. Summarize meta.json
if [ -f "meta.json" ]; then
    META_SUMMARY=$(cat meta.json | jq -c '.' 2>/dev/null || cat meta.json)
else
    META_SUMMARY="Meta file not found."
fi

# 4. Output to env_context.json
cat <<EJ > "$OUTPUT_FILE"
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "task_dir": "$TASK_DIR",
  "file_tree": $(echo "$FILE_TREE" | jq -R -s '.'),
  "log_tail": $(echo "$LOG_TAIL" | jq -R -s '.'),
  "meta_summary": $(echo "$META_SUMMARY" | jq -R -s '.')
}
EJ

echo "Context injected to $OUTPUT_FILE"
