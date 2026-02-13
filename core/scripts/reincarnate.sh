#!/bin/bash
# =================================================================
# OpenClaw "Isekai" (一键转生) Bootstrap Script V2.2
# 架构：Grand Unified Architecture (SSOT + Stateless Experts)
# 功能：拉取核心仓库 -> 部署 Conductor -> 链接专家 -> (可选) 覆盖 Main
# =================================================================

set -e

REPO_URL="git@github.com:hex1n/xiaobudian-bot-core-rules.git"
WORKSPACES_DIR="/root/.openclaw/workspaces"
CONDUCTOR_DIR="$WORKSPACES_DIR/conductor"
CORE_DIR="$CONDUCTOR_DIR/core"
EXPERTS=("coder" "ops" "watchdog" "scout" "writer")
CORE_FILES=("AGENTS.md" "HEARTBEAT.md" "IDENTITY.md" "MATRIX.md" "PROTOCOL.md" "SOUL.md" "TEAM.md" "TOOLS.md" "USER.md")

# Default: Ask user
OVERRIDE_MAIN="ask"

# Parse args
for arg in "$@"; do
    case $arg in
        --override-main) OVERRIDE_MAIN="yes" ;;
        --no-override-main) OVERRIDE_MAIN="no" ;;
    esac
done

echo "🌌 启动转生协议 V2.2 (Isekai Protocol)..."

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
    TARGET="$WORKSPACES_DIR/$agent"
    mkdir -p "$TARGET"
    
    # 净化：移除 Git 残留和旧文件 (Zero Retention Enforce)
    rm -rf "$TARGET/.git" "$TARGET/BOOTSTRAP.md" "$TARGET/tasks" "$TARGET/scripts"
    
    # 链接：建立指向 Conductor Core 的软链接
    for file in "${CORE_FILES[@]}"; do
        ln -sf "$CORE_DIR/$file" "$TARGET/$file"
    done
    echo "   ✅ $agent 已连接至 SSOT。"
done

# Writer 特殊处理
mkdir -p "$WORKSPACES_DIR/writer/drafts"

# 4. Main Agent 覆盖逻辑 (The Alias Strategy)
do_override=false

if [ "$OVERRIDE_MAIN" == "yes" ]; then
    do_override=true
elif [ "$OVERRIDE_MAIN" == "ask" ]; then
    echo "❓ 是否将 'conductor' 设置为默认 'main' Agent? (这将删除原 main 目录并创建软链)"
    read -p "   请输入 [y/N]: " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        do_override=true
    fi
fi

if [ "$do_override" = true ]; then
    echo "🔄 正在执行 '鸠占鹊巢' 操作 (Main -> Conductor)..."
    if [ -L "$WORKSPACES_DIR/main" ] && [ "$(readlink "$WORKSPACES_DIR/main")" == "$CONDUCTOR_DIR" ]; then
        echo "   ✅ Main 已经是 Conductor 的替身，跳过。"
    else
        echo "   ⚠️ 删除旧 Main 目录..."
        rm -rf "$WORKSPACES_DIR/main"
        ln -s "$CONDUCTOR_DIR" "$WORKSPACES_DIR/main"
        echo "   ✅ Main 已重定向至 Conductor。"
    fi
else
    echo "⏩ 跳过 Main 覆盖。OpenClaw 将使用默认 Main 或您配置的其他入口。"
fi

# 5. 完成
echo "------------------------------------------------"
echo "✨ 转生完成！(Reincarnation Complete)"
echo "当前版本：$(git -C $CONDUCTOR_DIR log -1 --pretty=format:'%h - %s')"
echo "架构状态：Unified Core + Stateless Experts"
echo "------------------------------------------------"
