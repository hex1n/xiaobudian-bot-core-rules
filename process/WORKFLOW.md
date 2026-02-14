# WORKFLOW.md — Claude Teams 风格（强复刻 / 模式2）

> 目标：**自然语言输入** → 系统自动路由为团队任务（Team Mode），Conductor 只做编排与签字。

## 1) 输入方式（模式2：不要求 TEAM 前缀）
- 你可以直接用自然语言描述需求。
- 系统会自动判断：
  - **默认 Team Mode**（Executor + Watchdog Verifier）
  - 仅在 **low risk + trivial** 时允许 Solo（必须自动记录 exception_reason）

## 2) 默认编队（Two-person rule）
- 每个任务至少包含：
  - **Executor**：按任务类型选择（Scout/Coder/Ops/Writer）
  - **Verifier**：固定为 **Watchdog**（强制）

## 3) 任务流转（最短闭环）
1. **Intake**：补齐目标/验收/风险（不足则先问，不执行）
2. **Plan**：选择 Executor；固定 Watchdog 为 Verifier
3. **Gate**：必须通过 `run_dispatch_plan.py`（preflight + tool-domain validator）
4. **Execute**：Executor 产出（AGENT_RETURN）
5. **Verify**：Watchdog 独立验收（PASS/FAIL + 证据）
6. **Ship**：Conductor 只写 DECISION（准入/拒绝/回滚/下一步）

## 4) 产物契约（必须）
- Executor 回包：`templates/AGENT_RETURN.md`
- Verifier 回包：同模板，但必须包含验收结论与证据

## 5) Solo 例外（仅限低风险）
允许 Solo 的条件（全部满足）：
- risk_level = low
- < 5 分钟
- 不需要外部抓取、不需要 exec、不需要改文件
- 且必须记录：`exception_reason`

## 6) 路由规则单一真源
- 路由/编队规则见：`core/ROUTER.md`
