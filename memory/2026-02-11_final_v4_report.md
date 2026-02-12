# 2026-02-11 模型容灾与架构终极演进 (v4.0)

## 核心成果
1. **模型战力别名化 (Intelligence Aliasing)**:
   - 成功将具体模型解耦为战力代号：`@pro-intelligence` (高阶逻辑), `@flash-intelligence` (极速响应), `@coding-intelligence` (代码特化)。
   - 建立了跨厂商冗余链：**Google -> Anthropic (Claude) -> Moonshot (Kimi) -> OpenAI (Codex)**。
2. **引导程序 (bootstrap.sh) 战斗化**:
   - 注入了演习中发现的 3 个实战补丁（指纹校验解耦、物理 Service 验证、printf 标准化）。
   - 集成了 **Post-Installation Validation** (安装后自动验收) 流程。
3. **哨兵保活 (Expert Liveness Check)**:
   - 哨兵 V2 正式上线，具备 3 分钟专家消息停滞（Stall）检测与报警能力。
4. **小不点新身份**:
   - 官方更名为 **小不点 (Little Bit)**，正式确立“总裁办数字管家”地位。

## 关键技术参数
- **Git Commit**: `bf83d38` (Combat-Hardened Bootstrap)。
- **物理事实源**: `/root/.openclaw/teamboard/tasks` (全局共享)。
- **容灾协议**: `DISPATCHER.md` 已增加“模型切换强制披露”及“落盘验证门禁”。

## 配置注意 (P4 修正)
- 经校验，`agents.defaults.models` 下的别名配置目前仅支持 `alias` 映射，底层不支持在该层级定义 `fallbacks`。
- **当前修正路径**：别名仅用于快速切换主模型，容灾 Fallback 逻辑由网关全局及厂商 Order 维持。

## 状态
系统已完成今日全量重构，进入“高可用、强闭环”运行态。
