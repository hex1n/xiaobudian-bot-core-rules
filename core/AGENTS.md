# AGENTS.md - 团队能力矩阵 (Intelligence Matrix)

> 本文件定义了各专家的智力水位线与能力边界，实现“任务复杂度 -> 智力等级”的动态匹配。

## 1. 智力分级定义 (Intelligence Tiers)
系统不锚定具体模型名称，而是根据 OpenClaw 网关当前的可用模型库进行动态指派：

- **Tier-1: Reasoning (思考型)**
  - 核心特质：具备深度推理链 (CoT)、极高逻辑鲁棒性。
  - 适用场景：架构设计、高风险系统变更、疑难 Bug 修复、复杂协议审计。
- **Tier-2: Production (专业型)**
  - 核心特质：平衡的速度与智力，极强的指令遵循能力。
  - 适用场景：日常业务逻辑开发、标准运维操作、深度调研汇报。
- **Tier-3: Express (响应型)**
  - 核心特质：极速响应、极低成本。
  - 适用场景：任务分发、日志预筛、看板更新、文档格式化。

## 2. 专家能力水位线 (Specialist Baseline)
| 专家 ID | 默认智力水位 | 自动加码条件 (Auto-Scale) |
| :--- | :--- | :--- |
| **conductor** | `Tier-3` | 在任务拆解 (Planning) 阶段自动申请 `Tier-2` |
| **coder** | `Tier-2` | 涉及多层级逻辑重构或核心库修改时，升级至 `Tier-1` |
| **ops** | `Tier-2` | 涉及内核参数、安全防火墙或 Root 级变更时，升级至 `Tier-1` |
| **watchdog** | `Tier-3` | 发现异常波动并需要进行根因定位时，升级至 `Tier-2` |
| **scout** | `Tier-2` | 需要对比多维度复杂技术方案时，申请 `Tier-2` |
| **writer** | `Tier-3` | 编写正式对外发布的技术白皮书时，申请 `Tier-2` |

## 3. 动态指派规则
- **按熵定阶**：Dispatcher 根据任务 `complexity` 标签（由 `session_status` 辅助评估）动态向网关申请对应 Tier 的模型。
- **环境适配**：若当前 VPS 无法提供 `Tier-1` 模型，系统将自动使用最接近的 `Tier-2` 代替，并记录在 `token_audit.md` 中。
