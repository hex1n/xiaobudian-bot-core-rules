# Team AutoRoute（模式2）

你可以直接发自然语言。

系统默认会自动走 Team Mode：
- Executor：按任务类型自动选择（Scout/Coder/Ops/Writer）
- Verifier：固定 Watchdog

只有在 **low risk + trivial** 时才会走 Solo，并自动记录 `exception_reason`。

如果你想强制指定：
- `TEAM:` 强制 Team Mode
- `SOLO:` 强制 Solo（必须给理由；否则会被拒绝）
