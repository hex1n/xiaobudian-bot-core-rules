# 根因分析报告 (RCA): 升级过程中的端口冲突与重启循环

**日期**: 2026-02-08
**分析专员**: 🧰 Ops

## 1. 故障现象分析
在执行 OpenClaw 升级重启过程中，系统陷入了持续约 15 分钟的“重启循环”。
*   **核心原因**: 旧的网关进程（如 PID 138309, 140568）在接收到 `SIGTERM` 后未能在 systemd 规定的时间内完全退出，或者在某种异常情况下沦为孤儿进程，继续持有端口 `18789`。
*   **PID 140568 来源**: 该进程是升级过程中由 systemd 尝试启动的一个实例，但在启动过程中由于某种竞态条件或旧进程残留，它成功锁定了端口但由于内部逻辑冲突（如发现另一个锁定文件）而未能注册为 systemd 的主进程，最终脱离了 systemd 的监管。

## 2. 风险溯源
*   **systemd 配置风险**:
    *   当前配置使用了 `KillMode=process`。这意味着当 systemd 停止服务时，它仅向主进程（Main PID）发送信号。如果网关生成了子进程，这些子进程可能在主进程退出后继续运行，导致端口占用。
    *   `Type=simple` 无法有效处理进程间的锁定交接。
*   **内部重启逻辑**:
    *   OpenClaw 内部存在锁定检测机制，但当检测到端口冲突时，它仅报告错误并尝试退出。如果退出逻辑受到阻塞（例如异步任务未完成），进程将继续占用端口。

## 3. 改进建议与 SOP 修改
为了彻底避免此类冲突，建议对升级 SOP 及配置进行以下修改：

### A. 修改 systemd 配置
1.  **改变 KillMode**: 将 `KillMode=process` 改为 `KillMode=control-group` (默认值)，确保 systemd 在停止服务时杀死整个控制组内的所有进程。
2.  **增加超时强制清理**: 显式设置 `TimeoutStopSec=30s`，确保挂起的进程在 30 秒内被 `SIGKILL`。

### B. 完善升级 SOP
在升级执行步骤中增加“确定性清理”环节：
1.  **停止服务**: `openclaw gateway stop` (或 `systemctl stop openclaw-gateway`)。
2.  **强制清理 (Pre-start Check)**: 增加一条命令检查端口占用：`fuser -k 18789/tcp || true`。
3.  **执行升级**: `npm install -g openclaw`。
4.  **启动并验证**: `openclaw gateway start`。

### C. 内部逻辑优化建议
*   在网关启动检测到 PID 文件或端口占用时，如果发现占用进程的命令名确实是 `openclaw-gateway` 且非当前进程，应提供强制接管端口的选择或自动尝试向旧 PID 发送信号。

## 4. 交付状态
报告已提交。目前系统网关已通过 `openclaw gateway restart` 恢复正常运行，Main PID 为 140971。
