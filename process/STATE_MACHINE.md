# 流程状态机（最小可执行版本）

> 目标：把“对话式派工”升级为“可恢复、可审计、可收口”的流程。

## 状态定义
1. **Intake**：接单，补齐 Goals/Non-goals/Acceptance/Constraints
2. **Plan**：分流与派工卡生成；明确人审门禁节点
3. **Execute**：子代理并行产出（必须按 AGENT_RETURN 回包）
4. **Verify**：统一验证（测试/检查/对照）+ 风险评估
5. **Ship**：合并/发布/同步（若有高风险必须人审确认）
6. **Retro**：沉淀模板、RCA、指标记录

## 状态转移门槛
- Intake → Plan：验收标准已明确；风险等级已定
- Plan → Execute：派工卡已生成；危险动作门禁已设置
- Execute → Verify：所有 workstreams 已回包或明确放弃
- Verify → Ship：验证通过；回滚可用；必要时 Big Boss 已确认
- Ship → Retro：产物已落盘；PR/版本已记录

## 必要产物（Artifacts）
- `/templates/TASK_BRIEF.md`（接单）
- `/templates/AGENT_RETURN.md`（回包）
- `/templates/RUNBOOK.md`（运维）
- `/templates/RCA.md`（复盘）
- `/templates/PR_TEMPLATE.md`（变更）

## 最小指标（建议记录在任务日志中）
- lead time（接单→交付）
- 返工次数（被退回）
- 高风险动作次数
- 验证失败原因分类
