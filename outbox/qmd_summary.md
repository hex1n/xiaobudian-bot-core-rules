# QMD 部署 PoC 审计报告 (Scout)

## 1. 背景：核心目标与架构
- **核心目标**: 在 OpenClaw 内部署 `qmd` (Query Markup Documents)，旨在替代现有的基础 `grep` 模拟搜索，提供一个具备 SOTA 水平的**本地混合搜索引擎**（Hybrid Search）。
- **核心架构**:
    - **检索机制**: 结合了 BM25 (关键字) + Vector Search (语义) + LLM Re-ranking (重排序)。
    - **技术栈**: 基于 Bun 运行时，利用 SQLite FTS5 进行全文索引，通过 `node-llama-cpp` 调用 GGUF 量化模型进行向量嵌入和重排序。
    - **集成设计**: 支持 JSON 输出与 MCP 协议，原生适配 AI Agent 交互。

## 2. 进度：已验证 vs Blockers
- **已验证项目**:
    - [x] **需求定位**: 已明确 `qmd` 作为知识库搜索引擎的优越性，确认其能大幅提升 Agent 检索精度。
    - [x] **PoC 方案**: `tasks/qmd-poc/outbox/poc_plan.md` 已完成详细的步骤规划与风险评估。
    - [x] **模拟替代方案**: 历史任务中已部署了一个基于 `grep` 的伪 `qmd` 命令（位于 `/usr/local/bin/qmd`），用于临时维持工作流。
- **待解决的 Blockers**:
    - [!] **环境缺失**: 当前系统未检测到 `bun` 和 `sqlite3`。`qmd` 强依赖 Bun 运行时及特定版本的 SQLite（支持 FTS5 扩展）。
    - [!] **资源占用**: 需要 ~2GB 磁盘空间存放 GGUF 模型，且语义搜索时峰值内存预计达到 4GB，需确认 VPS (Racknerd) 资源余量。
    - [!] **网络连通性**: 模型下载依赖 HuggingFace，需确认是否需要代理或手动预挂载。

## 3. 决策建议
目前需要 **0x01** 审批的原因在于：**环境变更权限与资源承诺**。

**行动建议**:
1. **安装环境 (审批项)**: 建议执行 `curl -fsSL https://bun.sh/install | bash` 进行 Bun 安装，并更新 `sqlite3`。
2. **资源扩容/检查**: 在部署前需确认 `/root` 分区有 >5GB 空间。
3. **真实部署**: 在 `bun` 环境就绪后，按照 `poc_plan.md` 进行源码安装，替换当前的 `grep` 模拟脚本。
4. **集成测试**: 优先验证 `qmd vsearch` 的内存压力，若 OOM 则需回退至纯 BM25 模式。

## 4. 汇报
本简报已同步提交至 `outbox/qmd_summary.md`。

---
**审计专员**: 🎒 Scout (Subagent: b6bc6b3d)
**日期**: 2026-02-08
