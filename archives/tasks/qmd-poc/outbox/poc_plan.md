# QMD 部署 PoC 方案 (草案)

## 1. 项目概况
- **项目名称**: QMD (Query Markup Documents)
- **项目地址**: https://github.com/tobi/qmd
- **核心功能**: 本地 Markdown 文档搜索引擎，结合 BM25、向量搜索和 LLM 重排序。
- **核心依赖**: Bun (>= 1.0.0), SQLite (macOS 需 Homebrew 版本), 本地 GGUF 模型 (约 2GB)。

## 2. PoC 目标与验证指标
### 2.1 目标
在受控环境中验证 QMD 的安装、索引、搜索功能及资源占用情况，确保其满足本地知识库检索需求。

### 2.2 验证指标 (KPIs)
- **安装成功率**: `bun install` 过程无未解决的依赖冲突。
- **索引准确性**: 能够正确读取指定目录的 Markdown 文件并生成 `docid`。
- **搜索有效性**:
  - `qmd search`: 关键词检索延迟 < 500ms。
  - `qmd vsearch`: 语义检索延迟 < 2s (首次加载模型后)。
  - `qmd query`: 混合检索结果相关度明显优于纯关键词检索。
- **资源占用**: 
  - 磁盘占用: 索引库体积 < 原始文档 2 倍；模型体积约 2GB。
  - 内存占用: 搜索时峰值内存 < 4GB (取决于模型量化版本)。

## 3. Step-by-step 操作清单
### 阶段 A: 环境准备
1. 确认系统已安装 `bun` (版本 >= 1.0.0)。
2. 确认 `sqlite3` 版本支持扩展 (或准备好 `brew install sqlite`)。
3. 准备测试数据集 (建议 10-50 篇不同主题的 Markdown 笔记)。

### 阶段 B: PoC 部署
1. **源码安装**: 
   ```bash
   git clone https://github.com/tobi/qmd.git
   cd qmd
   bun install
   bun link
   ```
2. **初始化集合**:
   ```bash
   qmd collection add <测试数据路径> --name poc-test
   ```
3. **建立索引**:
   ```bash
   qmd embed
   ```
   *注意：此步骤会触发模型下载 (约 2GB)，需确保网络通畅。*

### 阶段 C: 功能测试
1. **状态检查**: `qmd status`。
2. **基础搜索**: `qmd search "测试关键词"`。
3. **语义搜索**: `qmd vsearch "测试语义意图"`。
4. **混合搜索**: `qmd query "复杂查询"`。

## 4. 风险评估与应对
| 风险项 | 影响等级 | 应对措施 |
| :--- | :--- | :--- |
| **模型下载失败** | 高 | 预先确认 HF 连通性，或手动下载放置于 `~/.cache/qmd/models/`。 |
| **SQLite 扩展冲突** | 中 | 使用静态编译的 sqlite 或通过包管理器重装。 |
| **内存溢出 (OOM)** | 中 | 监控 `node-llama-cpp` 内存占用，必要时调小并发或换用更小模型。 |
| **存储空间不足** | 低 | 索引前检查 `~/.cache` 所在分区余量 (建议预留 5GB+)。 |

## 5. 回滚方案
### 5.1 软件卸载
1. 解除全局软链接: `bun unlink -g qmd` (或 `bun uninstall -g qmd`)。
2. 删除源码目录: `rm -rf <path_to_qmd>`。

### 5.2 数据清理
1. 删除索引库与缓存: `rm -rf ~/.cache/qmd`。
2. (可选) 清理 Bun 缓存: `bun pm cache clean`。

## 6. 待办清单 (Pending Tasks for 0x01)
- [ ] 审批此 PoC 方案。
- [ ] 确认 PoC 执行环境 (生产机/测试机/沙盒)。
- [ ] 授权 2GB 模型文件的磁盘占用权限。
- [ ] 确认是否需要集成到 MCP 协议供 Claude Desktop 使用。

---
**Ops 专员**: Subagent (ID: 2ca7b8b6)
**生成时间**: 2026-02-08 10:45
