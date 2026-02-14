# EXAMPLE DRILL — Teams 工作流演练（task_id=20260214-1609-teams-dryrun）

> 目的：提供一份可复制的“最小闭环演练”，验证 Intake→Plan→Gate→Execute→Verify→Ship。

## 0) Intake
- 任务单：参照 `templates/TASK_BRIEF.md`（本次演练实例在本地任务目录中，不纳入仓库）。

## 1) Plan
- 为 Scout/Writer 生成派工 JSON：
  - `assignee` 必须是 MATRIX 表中的专家名（如 `Scout` / `Writer`）
  - `requested_tools` 必须是 **真实工具名**（read/write/edit/exec/web_fetch/browser...），不要填 tag（如 systemd）

## 2) Gate（权限校验）
```bash
# 一键自检（推荐）
bash core/scripts/validate_dispatch_validator.sh

# 或对单个任务 JSON 校验
python3 core/scripts/dispatch_validator.py /path/to/task.json
```

## 3) Execute（产出回包）
- Scout 按 `templates/AGENT_RETURN.md` 回包：至少 3 个来源链接 + 对比表 + P0/P1/P2 建议。
- Writer 基于 Scout 回包产出 1 页 Markdown：TL;DR + 对比表 + 差距/风险 + 路线图。

## 4) Verify
- 检查回包是否：
  - 结构化（按模板）
  - 可追溯（有链接/路径/证据）
  - 可执行（有清单/产物）

## 5) Ship
- 将最终 Markdown 落到仓库（建议 `docs/` 或 `process/`），并走 PR 模板进行验收。
