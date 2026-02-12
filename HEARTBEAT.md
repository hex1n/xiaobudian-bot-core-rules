每次 heartbeat 执行看板审计，异常按原因分组展示。

数据来源
- ./status_snapshot.md
- ./tasks/<id>/outbox/dispatcher_status_log.md

读取规则
1) 从 ./status_snapshot.md 取 active 任务（planning executing verifying blocked）
2) 对每个 active 任务，从 dispatcher_status_log.md 中提取最后一条 touch_last
3) 异常原因以快照列 abnormal_reason 为准，取值 blocked 或 overdue

输出格式
看板审计：<当前时间>
活跃任务：<N>

每个任务输出：
- <task_id>  <state>  <title>
  最后进展时间：<last_touch_at>
  最后进展内容：<last_touch_note>

阻塞任务：<B>
若 B=0 输出：阻塞任务：无
若 B>0 列出每条，并提示需要 0x01 决策：继续 或 终止

超时任务：<O>
若 O=0 输出：超时任务：无
若 O>0 列出每条，并提示需要 0x01 决策：继续 或 终止
