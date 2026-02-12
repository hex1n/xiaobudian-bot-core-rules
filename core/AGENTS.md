# AGENTS.md - 专家能级配置 (Intelligence Matrix)

> 本文件定义了各专家的物理位置与智力水位线，是 Conductor 进行资源调度的配置依据。

## 1. 专家清单 (Experts)
| 专家 ID | 工作区路径 | 默认智力水位 (Baseline) |
| :--- | :--- | :--- |
| **conductor** | `/root/.openclaw/workspaces/conductor` | `Tier-3` (Planning 阶段自动加码至 `Tier-2`) |
| **coder** | `/root/.openclaw/workspaces/coder` | `Tier-2` (重构阶段自动申请 `Tier-1`) |
| **ops** | `/root/.openclaw/workspaces/ops` | `Tier-2` (高风险变更自动申请 `Tier-1`) |
| **watchdog** | `/root/.openclaw/workspaces/watchdog` | `Tier-3` (排障阶段自动申请 `Tier-2`) |
| **scout** | `/root/.openclaw/workspaces/scout` | `Tier-2` |
| **writer** | `/root/.openclaw/workspaces/writer` | `Tier-3` |

## 2. 智力池定义 (Intelligence Pool)
- **Tier-1 (Reasoning)**: 深度逻辑推理模型。
- **Tier-2 (Production)**: 稳定业务处理模型。
- **Tier-3 (Express)**: 极速任务分发模型。
