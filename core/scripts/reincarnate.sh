#!/bin/bash
# =================================================================
# OpenClaw "Isekai" (一键转生) Bootstrap Script V2.1
# 架构：Grand Unified Architecture (SSOT + Stateless Experts)
# 目标：拉取核心仓库 -> 部署 Conductor -> 强行软链所有专家
# =================================================================

set -e

REPO_URL="git@github.com:hex1n/xiaobudian-bot-core-rules.git"
CONDUCTOR_DIR="/root/.openclaw/workspaces/conductor"
CORE_DIR="$CONDUCTOR_DIR/core"
EXPERTS=("coder" "ops" "watchdog" "scout" "writer")
CORE_FILES=("AGENTS.md" "HEARTBEAT.md" "IDENTITY.md" "MATRIX.md" "PROTOCOL.md" "SOUL.md" "TEAM.md" "TOOLS.md" "USER.md")

echo "🌌 启动转生协议 V2.1 (Isekai Protocol)..."

# 1. 恢复主控 (Conductor Restoration)
if [ -d "$CONDUCTOR_DIR/.git" ]; then
    echo "🔄 检测到 Conductor 存在，正在从云端拉取最新灵魂..."
    cd "$CONDUCTOR_DIR"
    git fetch origin
    git reset --hard origin/main
else
    echo "🛸 正在从虚空中克隆 Conductor (SSOT)..."
    rm -rf "$CONDUCTOR_DIR"
    git clone "$REPO_URL" "$CONDUCTOR_DIR"
fi

# 2. 恢复目录结构 (Skeleton Restoration)
echo "🏗️ 重建数据结构..."
mkdir -p "$CONDUCTOR_DIR/memory/archive"
mkdir -p "$CONDUCTOR_DIR/tasks/outbox"
mkdir -p "$CONDUCTOR_DIR/logs"
mkdir -p "$CONDUCTOR_DIR/archives"

# 3. 专家连接 (Neural Linkage)
echo "🔗 正在将专家接入主控核心 (Symlink Enforcement)..."
for agent in "${EXPERTS[@]}"; do
    TARGET="/root/.openclaw/workspaces/$agent"
    
    # 确保目录存在
    mkdir -p "$TARGET"
    
    # 净化：移除 Git 残留和旧文件 (Zero Retention Enforce)
    rm -rf "$TARGET/.git" "$TARGET/BOOTSTRAP.md" "$TARGET/tasks" "$TARGET/scripts"
    
    # 链接：建立指向 Conductor Core 的软链接
    for file in "${CORE_FILES[@]}"; do
        # 强制覆盖旧链接或文件
        ln -sf "$CORE_DIR/$file" "$TARGET/$file"
    done
    
    echo "   ✅ $agent 已连接至 SSOT。"
done

# 4. 特殊处理 (Special Handling)
# Writer 需要草稿箱
mkdir -p "/root/.openclaw/workspaces/writer/drafts"
echo "   ✅ Writer 草稿箱已就绪。"

# 5. 完成
echo "------------------------------------------------"
echo "✨ 转生完成！(Reincarnation Complete)"
echo "当前版本：$(git -C $CONDUCTOR_DIR log -1 --pretty=format:'%h - %s')"
echo "架构状态：内核统一 (Unified Core) + 专家无状态 (Stateless Experts)"
echo "------------------------------------------------"
