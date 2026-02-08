# OpenClaw 升级操作清单 (20260208)

## 目标版本
- **版本号**: 2026.2.6-3

## 执行步骤 (Ops Checklist)

### 第一阶段：前置准备
1. [ ] **数据备份**：备份整个 `/root/.openclaw/` 目录。
   - `tar -czvf /root/openclaw_backup_20260208.tar.gz /root/.openclaw/`
2. [ ] **状态检查**：确认当前所有 Gateway 进程运行正常。
   - `openclaw gateway status`

### 第二阶段：执行升级
1. [ ] **停止服务**：停止所有运行中的 OpenClaw 实例。
   - `openclaw gateway stop`
2. [ ] **版本更新**：执行全局安装命令（需确保网络畅通）。
   - `npm install -g openclaw@2026.2.6-3`
3. [ ] **清理缓存**（可选）：如果遇到依赖冲突。
   - `npm cache clean --force`

### 第三阶段：启动与验证
1. [ ] **启动服务**：
   - `openclaw gateway start`
2. [ ] **版本确认**：
   - `openclaw --version` (应显示 2026.2.6-3)
3. [ ] **功能拨测**：
   - 检查 Discord/WhatsApp 连通性。
   - 验证 Browser/Canvas 工具是否正常加载。

---

# 回滚预案 (Rollback Plan)

## 触发条件
- 升级后服务无法启动且日志报错指向核心依赖。
- 关键功能（如消息收发、工具调用）持续失效。

## 回滚步骤
1. [ ] **停止异常进程**：
   - `openclaw gateway stop` (或通过 `ps -ef | grep openclaw` 强制 kill)
2. [ ] **版本回退**：
   - `npm install -g openclaw@2026.2.3-1`
3. [ ] **恢复数据**（如配置文件损坏）：
   - `mv /root/.openclaw /root/.openclaw_failed_upgrade`
   - `tar -xzvf /root/openclaw_backup_20260208.tar.gz -C /`
4. [ ] **重启验证**：
   - `openclaw gateway start`
   - `openclaw --version`
