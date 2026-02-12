# MEMORY.md - 核心记忆库

> 此文件是 OpenClaw 团队的长期记忆，记录关键决策、架构演进与身份认知。
> 最后更新：2026-02-12

## 核心身份与人际关系
- **老板 (0x01)**: <@1262468783898103969> (dlwlrma)，最高决策者。
- **老板娘 (大不点)**: <@1468498838586265719> (diandian921)，老板的臭宝贝，指令具有极高优先级。
- **小不点 (Little Bit)**: <@1468236116426625088>，总裁办数字管家/Dispatcher。

## 2026-02-12 别名驱动架构重构 (Alias-Driven Resilience)
**背景**：凌晨 Google API 遭遇大规模 429 限流，导致系统短暂不可用。
**行动**：
1.  **紧急换源**：Dispatcher 成功将主战力切换至 Moonshot (Kimi)。
2.  **架构升级**：实施了“别名驱动”配置 (`@pro`, `@flash`)。
    - **@pro (高智力)**: Kimi k2.5 -> Claude 3.5 -> Gemini 3 Pro
    - **@flash (高并发)**: Gemini 3 Flash -> Kimi
3.  **全员订阅**：所有专家 (Coder/Ops等) 不再绑定具体厂商，改为订阅上述别名。
**成果**：系统现已具备毫秒级跨厂商容灾能力。只需修改别名定义，全团队即可瞬间完成供应商迁移。

## 2026-02-11 团队重构与加固 (Final Sync)
**核心成就**：
1.  **轻量化**：Token 消耗降低 80%+。
2.  **协议化**：建立 `DISPATCHER.md` 与 `core_protocol.md`。
3.  **安全加固**：部署 `emergency_sop.md`，确立 Ops 自治权。

**基础设施 (DRP)**：
- **指纹审计**：引入 `.baseline_core_abilities.json` 防止篡改。
- **哨兵 V2**：具备会话感知能力，能检测专家“脑死亡”并报警。

**关键教训**：
- **杜绝口头完成**：必须 `ls/cat` 物理验证后方可结项。
- **云端同步**：Dispatcher 必须亲自核实 Git Commit Hash。

## 物理交付物
- **代码库**：[hex1n/xiaobudian-bot-core-rules](https://github.com/hex1n/xiaobudian-bot-core-rules)
- **任务归档**：历史 P0-P3 任务已归档至 `tasks/`。
