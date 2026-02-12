#!/bin/bash
# =================================================================
# OpenClaw "Isekai" (一键转生) Bootstrap Script
# 目标：从干净的 GitHub 规约仓库一键克隆并恢复工作区
# =================================================================

REPO_URL="git@github.com:hex1n/xiaobudian-bot-core-rules.git"
TARGET_DIR="/root/.openclaw/workspaces/conductor"

echo "🌌 开始转生流程..."

# 1. 检查环境
if [ ! -d "$TARGET_DIR" ]; then
    echo "📂 创建工作区目录..."
    mkdir -p "$TARGET_DIR"
fi

# 2. 拉取/更新核心规约
if [ -d "$TARGET_DIR/.git" ]; then
    echo "🔄 检测到已有工作区，正在拉取最新灵魂规约..."
    cd "$TARGET_DIR" && git fetch origin && git reset --hard origin/main
else
    echo "🛸 正在从云端克隆核心灵魂..."
    git clone "$REPO_URL" "$TARGET_DIR"
    cd "$TARGET_DIR"
fi

# 3. 恢复目录结构安全网
echo "🏗️ 恢复运行时目录结构..."
mkdir -p tasks memory archives configs scripts/utils docs teams_rules

# 4. 验证核心协议
if [ -f "core/DISPATCHER.md" ]; then
    echo "✅ 灵魂核心 (DISPATCHER) 已就位。"
else
    echo "❌ 警告：未发现核心协议，请检查仓库内容。"
fi

# 5. 生成本地环境提示
echo "------------------------------------------------"
echo "✨ 转生完成！"
echo "当前版本：$(git log -1 --pretty=format:'%h - %s')"
echo "工作区路径：$TARGET_DIR"
echo "下一步：运行 'openclaw gateway restart' 以应用最新配置。"
echo "------------------------------------------------"
