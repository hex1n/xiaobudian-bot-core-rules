# 0x01 常用 VPS 运维指令备忘录

本备忘录侧重于 `openclaw` 命令行工具的使用，涵盖基础控制、深度自检、任务管理及环境检查，旨在提升 VPS 运维效率。

## 1. 基础控制 (Core Control)
用于管理 OpenClaw 核心服务的运行状态。

*   **查看服务状态**
    *   说明：检查 OpenClaw Gateway 服务是否正在运行。
    *   指令：`openclaw gateway status`
*   **重启服务**
    *   说明：当服务出现异常或更新配置后，使用此命令重启 Gateway。
    *   指令：`openclaw gateway restart`
*   **查看日志**
    *   说明：实时查看系统运行日志，用于排查错误。
    *   指令：`openclaw gateway log` (或 `tail -f` 相关日志文件)

## 2. 深度自检 (Deep Inspection)
用于分析特定会话的详细信息及权限状态。

*   **查看会话详情**
    *   说明：通过指定 Key 查看会话的详细状态。
    *   指令：`openclaw sessions status --key <key> --verbose`
    *   **如何查看 Elevated (提权) 状态：**
        *   在 `--verbose` 输出的 JSON 或详细列表中，寻找 `capabilities` 或 `elevated` 字段。
        *   如果 `elevated: true`，说明该会话拥有高级权限（如执行敏感系统命令）。
        *   示例：`openclaw sessions status --key main --verbose`

## 3. 任务清理 (Task Management)
用于管理和清理后台运行的异步任务或挂起的会话。

*   **列出所有会话**
    *   说明：查看当前系统活跃的所有会话 ID 和基本信息。
    *   指令：`openclaw sessions list`
*   **终止指定任务/会话**
    *   说明：强制杀死异常卡死或不再需要的会话。
    *   指令：`openclaw sessions kill --key <key>`
    *   示例：`openclaw sessions kill --key subagent-123`

## 4. 环境检查 (Environment Check)
确保 VPS 基础依赖和工具版本正确。

*   **GitHub 授权状态**
    *   说明：检查 VPS 是否已成功登录 GitHub，确保代码同步或 Gist 操作正常。
    *   指令：`gh auth status`
*   **版本自检**
    *   说明：确认当前安装的 OpenClaw 版本。
    *   指令：`openclaw --version`

---
*Last Updated: 2026-02-08*