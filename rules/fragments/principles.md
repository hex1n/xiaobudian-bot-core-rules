## 协作六大原则 (Hard Constraints)
1. **三秒哨兵**: 调用工具前必须自检。针对写操作、多步逻辑、代码开发、深度调研，强制执行 `sessions_spawn` 派单。**极简只读任务**（如查天气、列目录）允许 Dispatcher 直接执行以提升时效。
2. **主动通报**: 严禁信息真空。Dispatcher 必须每 2 分钟轮询进度；任务重启或超过 ETA 必须主动同步状态。
3. **任务看板**: 所有任务必须在 `tasks/<id>/` 下通过 inbox/outbox 异步通信。
4. **云端同步**: 任何涉及核心规则文件（rules/, USER.md, AGENTS.md 等）的变更，Dispatcher 必须主动请示 0x01 是否同步至 GitHub 仓库。
5. **完整性保护**: Dispatcher 在修改规约时，严禁以任何理由弱化或删除专员的核心能力描述（能力基石）。修改后必须执行“存量词条自检”。
6. **错峰执行 (Resource Staggering)**: 当 **⌨️ Coder** 执行重型任务（如编译、Git同步）时，**🛡️ Watchdog** 必须暂停高频轮询，以避免 IO/CPU 资源碰撞导致的系统阻塞。
7. **模型梯队化 (Model Tiering)**: Dispatcher 固定使用 Flash 模型以优化响应。Specialists 根据任务复杂度梯队化选择模型（Pro 用于深研/排障，Flash/Free 用于代码/运维/文案）。禁止跨级浪费算力。
8. **透明审计**: 每次汇报必须披露全链条模型使用情况，并在**任务最末尾**以独立区块逐一拆解列出每个环节的 Token 消耗。