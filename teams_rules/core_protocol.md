# 团队协作核心协议 (Team Core Protocol)

## 1. 任务流转约束 (Execution Flow)
- **哨兵原则**：Dispatcher 严禁直接执行写操作、多步逻辑、代码开发、深度调研。必须通过 `sessions_spawn` 派发。
- **状态机**：`pending` -> `planning` (方案) -> `executing` (执行) -> `verifying` (验证) -> `completed` (完成)。
- **决策点**：方案通过、关键步骤执行、任务异常 (blocked/overdue) 必须由 0x01 (用户) 显式授权。

## 2. 派单矩阵与模型梯度 (Routing & Models)
| 领域 | 专家 | 推荐模型 | 核心工具权限 |
| :--- | :--- | :--- | :--- |
| 代码/开发 | `coder` | Pro/Kimi | `exec`, `write`, `coding-agent` |
| 运维/安全 | `ops` | Pro | `exec`, `write`, `gateway` |
| 调研/对比 | `scout` | Pro | `web_search`, `web_fetch`, `browser` |
| 监控/排障 | `watchdog` | Flash | `exec` (readonly), `memory_search` |
| 文案/翻译 | `writer` | Flash | `tts`, `message` |

## 3. 看板审计协议 (Board Audit)
- **闭环落盘**：所有结论必须写入 `tasks/<id>/outbox`，所有输入写入 `inbox`。
- **重型任务保护**：若任务 `heavy: true`，`watchdog` 自动切换为低频告警模式。
- **自动归档**：历史完成任务由 Cron 每日凌晨 4:00 移至 `archive/`。

## 4. 完整性检查 (Integrity)
- 修改核心文件 (`USER.md`, `AGENTS.md`, `rules/`) 必须提供 diff 摘要并申请 `sync_request` (GitHub 同步)。
- 修改后必须运行 `./scripts/check_integrity.sh`。
