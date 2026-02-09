# MEMORY.md - Long-Term Storage

## Key Metadata
- **Owner**: 0x01
- **Relationship**: Partner with 大不点 (diandian921)
- **Comm Style**: 喜欢自然轻松、但不失严谨高效的沟通

## Infrastructure Log
- **2026-02-08**: 严重违规事件复盘。
  - **事件**：小不点在主进程直接执行了 idx.md 调研与版本更新分析，违反了 `TEAM.md` 调度规范。
  - **纠偏**：固化“三秒哨兵”原则，确立 Dispatcher 身份硬约束。
  - **准则**：专业任务（Scout/Ops/Writer/Watchdog）严禁在 Main Session 直接执行，必须派单。
- **2026-02-09**: 遭遇 `opencode` 内存爆发与 Git 操作的资源碰撞，导致 Gateway 消息阻塞。确立“错峰执行”原则，强制 Watchdog 在重型任务期间避让。同时，因处理子代理结果导致主进程陷入“思维死循环”及“思维泄露”。
  - **修复**：更新 `AGENTS.md` 增加“逻辑熔断器”（防止工具/思考死循环）、“思维泄露管理”及“上下文剪裁（Summarize-first）”规约。
- **2026-02-08**: 完成上下文大扫除。
  - 精简了 AGENTS.md 和 SOUL.md。
  - 配置了 workspaceFiles 硬隔离，大幅降低 Token 固定开销。
  - 确立了“指令服从、一步一确认”的回滚修正准则。

## Project Context
- 目前正在进行 OpenClaw 的性能与成本优化。
