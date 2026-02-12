#!/bin/bash
# =================================================================
# OpenClaw "Isekai" (一键转生) Bootstrap Script
# 目标：在全新 VPS 上一键安装并克隆 conductor 灵魂
# =================================================================

set -e # 遇错即停，方便排查

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🌌 欢迎使用 OpenClaw 一键转生程序...${NC}"

# --- 1. 交互式配置 ---
echo -e "${YELLOW}🛠️  配置阶段 (按回车使用括号内的默认值)${NC}"

# 获取 GitHub 仓库
read -p "请输入 GitHub 灵魂仓库地址 (git@github.com:hex1n/xiaobudian-bot-core-rules.git): " REPO_URL
REPO_URL=${REPO_URL:-"git@github.com:hex1n/xiaobudian-bot-core-rules.git"}

# 获取工作区路径
read -p "请输入工作区安装路径 (/root/.openclaw/workspaces/conductor): " TARGET_DIR
TARGET_DIR=${TARGET_DIR:-"/root/.openclaw/workspaces/conductor"}

# 获取 OpenClaw Token (交互式防止泄露)
read -s -p "请输入 OpenClaw Gateway Token (若已有配置可跳过): " OC_TOKEN
echo ""

# --- 2. 检查依赖 ---
check_deps() {
    echo -e "${YELLOW}🔍 正在检查运行环境...${NC}"
    for cmd in git node npm; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}❌ 缺失 $cmd, 正在尝试安装...${NC}"
            # 这里可以根据系统增加 apt/yum 安装逻辑，此处先提示
            echo "请先手动安装 $cmd 后重新执行本脚本。"
            exit 1
        fi
    done
    
    if ! command -v openclaw &> /dev/null; then
        echo -e "${YELLOW}⚙️  安装 OpenClaw CLI...${NC}"
        npm install -g openclaw || (echo "安装失败，请检查网络" && exit 1)
    fi
}

# --- 3. 克隆/拉取仓库 ---
sync_repo() {
    echo -e "${YELLOW}🛸 正在同步灵魂规约...${NC}"
    if [ -d "$TARGET_DIR/.git" ]; then
        echo "检测到已有目录，尝试更新..."
        cd "$TARGET_DIR" && git fetch --all && git reset --hard origin/main
    else
        mkdir -p "$(dirname "$TARGET_DIR")"
        git clone "$REPO_URL" "$TARGET_DIR" || {
            echo -e "${RED}❌ 克隆失败。请检查 SSH Key 是否已添加到 GitHub。${NC}"
            exit 1
        }
        cd "$TARGET_DIR"
    fi
    # 恢复运行时必要结构
    mkdir -p tasks memory archives configs scripts/utils docs teams_rules
}

# --- 4. 自动生成配置文件 (交互式补全) ---
configure_gateway() {
    CONFIG_PATH="/root/.openclaw/openclaw.json"
    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "${YELLOW}📝 初始化网关配置...${NC}"
        openclaw gateway config init --token "$OC_TOKEN" --port 18789
    else
        echo -e "${GREEN}✅ 已发现现有配置，跳过初始化。${NC}"
    fi
}

# --- 5. 执行流程 ---
trap 'echo -e "${RED}🛑 脚本执行中断或失败，您可以修复环境后重新执行。${NC}"' ERR

check_deps
sync_repo
configure_gateway

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}✨ 转生成功！${NC}"
echo -e "当前灵魂版本: $(git log -1 --pretty=format:'%h - %s')"
echo -e "工作区路径: $TARGET_DIR"
echo -e "\n${YELLOW}下一步建议：${NC}"
echo -e "1. 运行 'openclaw gateway start' 启动网关"
echo -e "2. 如果是新环境，请运行 'openclaw agent add' 将该工作区关联为 conductor"
echo -e "${GREEN}================================================${NC}"
