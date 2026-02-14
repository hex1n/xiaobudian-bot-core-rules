# ROUTER.md — Claude Teams 风格路由（模式2）

> 单一真源：把自然语言任务映射为 (Executor + Watchdog) 编队。

## 默认规则
- **默认 Team Mode**：除非明确命中 trivial+low-risk。
- **强制 Verifier**：Watchdog。

## 分类与编队
| 类别 | 触发词/特征（示例） | Executor | Verifier |
|---|---|---|---|
| news / 热点 | 新闻、热点、24小时、帖子汇总 | Scout + Writer（可并行） | Watchdog |
| research / 调研 | 对比、调研、最佳实践、框架选型 | Scout | Watchdog |
| docs / 规范 | 规约、文档、README、流程 | Writer | Watchdog |
| coding / 脚本 | 代码、脚本、重构、实现、单测 | Coder | Watchdog |
| ops / 部署 | 上线、重启、配置、cron、证书 | Ops | Watchdog |
| incident / 排障 | 报错、超时、不可用、日志 | Watchdog（可做 executor） | Watchdog（需要第二验收者时：Writer 复核结论） |

## trivial 判定（允许 Solo 的唯一入口）
必须同时满足：
- low risk
- 不需要外部抓取/exec/写文件
- 预期 < 5 分钟

并且必须在最终回复中写入：`exception_reason`（可一句话）。
