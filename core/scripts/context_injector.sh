#!/bin/bash
# context_injector.sh - V2.1 情境感知注入脚本
TASK_DIR=$(pwd)
OUTPUT_FILE="env_context.json"

# 识别 Heat Level (任务目录中的关键词)
HEAT_LEVEL=1
if [[ "$TASK_DIR" == *"URGENT"* ]] || [[ "$TASK_DIR" == *"CORE"* ]] || [[ "$TASK_DIR" == *"CRITICAL"* ]]; then
    HEAT_LEVEL=2
fi

# 1. 生成文件树
FILE_TREE=$(find . -maxdepth 2 -not -path '*/.*' | sed -e 's/[^-][^\/]*\// |/g' -e 's/|/  /g' -e 's/  -/  |/')

# 2. 提取日志摘要
LOG_TAIL=$(tail -n 3 dispatcher_status_log.md 2>/dev/null || echo "N/A")

# 3. 输出 JSON
cat <<EJ > "$OUTPUT_FILE"
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "heat_level": $HEAT_LEVEL,
  "task_dir": "$TASK_DIR",
  "file_tree": $(echo "$FILE_TREE" | jq -R -s '.'),
  "log_tail": $(echo "$LOG_TAIL" | jq -R -s '.')
}
EJ

echo "Context injected to $OUTPUT_FILE with Heat Level: $HEAT_LEVEL"
