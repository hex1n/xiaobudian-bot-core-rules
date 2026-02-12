#!/bin/bash
# Conductor Workspace Sanity Check & Sync Prep

echo "🔍 正在扫描工作区..."

# 1. 识别冗余
TASK_COUNT=$(find tasks -maxdepth 1 -type d | wc -l)
MEM_COUNT=$(find memory -name "*.md" | wc -l)

echo "📊 统计结果:"
echo "  - 任务过程目录: $TASK_COUNT (建议忽略)"
echo "  - 每日流水文件: $MEM_COUNT (建议忽略)"

# 2. 检查核心文件
CORE_FILES=("DISPATCHER.md" "AGENTS.md" "USER.md" "MEMORY.md" "IDENTITY.md" "SOUL.md")
echo "📄 核心规约状态:"
for file in "${CORE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  [OK] $file"
    else
        echo "  [??] $file (缺失)"
    fi
done

echo ""
echo "💡 整理方案:"
echo "1. 应用新的 .gitignore"
echo "2. 更新 README.md 为导航模式"
echo "3. 执行 git rm -r --cached . 重新索引"
echo "4. Commit 并 Push"
