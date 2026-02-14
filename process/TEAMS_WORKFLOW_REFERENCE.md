# Teams（主 Agent + 专家 Agent）工作流：社区实践对标与落地建议

> 来源：演练 task_id=20260214-1609-teams-dryrun 的 Writer 产物节选（已脱离 AGENT_RETURN 外壳，便于直接引用）。

## TL;DR
- 社区主流 multi-agent 的分水岭：**从“会聊天”到“可运行的工程系统”**。
- 关键四件套：**可持久编排（state/durable）**、**人审门禁（HITL）**、**结构化交付（contract）**、**可观测/可验证（tracing+tests/evals）**。
- LangGraph 代表“编排底座”：强调 durable execution 与 interrupts。
- AutoGen 代表“系统框架”：事件驱动 + 可扩展 runtime/工具集成。
- CrewAI/OpenHands/SWE-agent 更偏“流程/产品/工程闭环”：强调 guardrails、structured outputs、权限与评测。

## 社区三种路线简述
### 1) LangGraph：编排与可恢复执行（stateful orchestration）
- 重点：durable execution（可中断/恢复/长任务）、human-in-the-loop、memory、debugging/visibility。
- 适合：把多代理协作做成“可运行的状态机/图”。
- 参考：https://docs.langchain.com/oss/python/langgraph/overview

### 2) AutoGen：事件驱动的多代理系统框架
- 重点：AgentChat（对话式多代理应用）+ Core（可扩展事件驱动系统）+ Extensions（工具/执行器/runtime）。
- 适合：需要更强组合性、并行协作、多 runtime/工具集成的 teams 系统。
- 参考：https://microsoft.github.io/autogen/stable/

### 3) CrewAI / OpenHands / SWE-agent：流程化、产品化与工程验证
- CrewAI：强调 tasks&processes（顺序/层级/混合）+ guardrails + HITL + structured outputs。
  - https://docs.crewai.com/
- OpenHands：产品形态（SDK/CLI/GUI/Cloud），提到 RBAC/permissions、多用户协作、benchmarks。
  - https://github.com/OpenHands/OpenHands
- SWE-agent：强调 agent-computer interface（ACI）对“真实软件工程任务”的性能提升，并通过基准评测说明。
  - https://arxiv.org/abs/2405.15793

## 对比表（关键维度）
| 体系/框架 | 编排/状态管理 | 权限/工具门禁 | 可观测性 | 评测/验证 |
|---|---|---|---|---|
| LangGraph | 强：stateful graph + durable execution | 强：interrupts 支持人审 | 强：强调调试/可视化（LangSmith 生态） | 中：底座为主，验证靠接入 |
| AutoGen | 中-强：Core 事件驱动 | 中：通过 runtime/扩展实现约束 | 中：需你补观测链路 | 中：需你定义验收/测试 |
| CrewAI | 中：flows + processes | 强：guardrails/HITL | 中：文档强调可观测 | 中：structured outputs + 流程验收 |
| OpenHands | 中：产品化工作流 | 强：RBAC/permissions 倾向 | 中-强：更易接入会话/集成观测 | 强：提到 benchmarks |
| SWE-agent | 中：围绕 ACI + 回路 | 中：通过接口约束工具使用 | 中：依赖实现 | 强：SWE-bench/HumanEvalFix 等 |

## 我们当前体系的差距与风险（5 点）
1) **状态不可恢复**：现在更多是“对话式派工”，一旦中断/重启/上下文重置，任务状态丢失。
2) **工具请求语义易误用**：requested_tools 若混入 tag（如 systemd）会产生误判；需要强规范。
3) **人审门禁需制度化**：高风险动作必须有结构化暂停点与确认格式。
4) **可观测缺口**：缺少最小指标（lead time/返工/门禁触发/失败原因）。
5) **验证不工程化**：目前已做 validator 自检，但还没进入 CI/PR Gate。

## 改造路线图（P0/P1/P2）
**P0（今天就能做）**
- 统一规定 requested_tools 只能填“真实工具名”，tag 只在 MATRIX 内部展开。
- 在 TASK_BRIEF 中固定“人审 interrupt 点”字段（Plan/Execute/Ship）。

**P1（1-2 周）**
- 将流程固化为最小状态机（Intake→Plan→Execute→Verify→Ship→Retro），并要求产物落盘到 task 目录。
- 引入二级收口：writer/ops/coder/watchdog 各自负责可验收产物，Conductor 只签字。

**P2（持续演进）**
- 把 validator 自检脚本接入 GitHub Actions，作为 PR 必过门禁。
- 增加最小指标记录与定期复盘（每周一次）。
