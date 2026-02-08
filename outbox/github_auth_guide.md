# GitHub 私有仓库访问配置指引

为了让 OpenClaw 能够管理 GitHub 私有仓库，我们需要配置身份验证。以下是两种主流方案的对比及操作指南。

## 1. 方案对比

| 维度 | SSH 密钥 (推荐) | Personal Access Token (PAT) |
| :--- | :--- | :--- |
| **主要用途** | 持续的 Git 操作（Clone, Push, Pull） | 脚本调用、API 操作、临时访问 |
| **安全性** | 基于非对称加密，私钥留在本地，安全性高 | 类似密码，一旦泄露需立即吊销 |
| **便利性** | 配置一次，永久使用；无需频繁输入密码 | 需手动管理过期时间（建议设置有效期） |
| **适用场景** | **OpenClaw 服务器环境的长期身份验证** | 自动化 CI/CD 或特定 API 集成 |

---

## 2. 操作指南：SSH 密钥方案 (推荐)

### 第一步：生成密钥对
在 OpenClaw 终端执行以下指令（请将 `your_email@example.com` 替换为你的 GitHub 邮箱）：

```bash
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/github_openclaw
```
*提示：当询问 `Enter passphrase` 时，直接按回车（不设密码）以方便 OpenClaw 自动化调用，或设置密码以增加安全性。*

### 第二步：配置 SSH Config
执行以下指令，确保 SSH 自动使用该密钥访问 GitHub：

```bash
cat <<EOF >> ~/.ssh/config

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_openclaw
EOF
chmod 600 ~/.ssh/config
```

### 第三步：将公钥添加到 GitHub
1. 执行指令查看公钥内容：
   ```bash
   cat ~/.ssh/github_openclaw.pub
   ```
2. 复制输出的整行字符串。
3. 访问 GitHub [SSH and GPG keys 设置页面](https://github.com/settings/keys)。
4. 点击 **New SSH key**。
5. Title 建议填写：`OpenClaw-Racknerd`。
6. 将复制的内容粘贴到 **Key** 输入框中，点击 **Add SSH key**。

---

## 3. 风险与安全性说明

- **存储位置**：
    - **SSH**：私钥存储在 `~/.ssh/` 目录下。该目录权限应严格限制（600），防止其他用户读取。
    - **PAT**：通常存储在环境变量（如 `.env` 或 `~/.bashrc`）中。
- **潜在风险**：
    - 如果 OpenClaw 所在服务器被攻破，存储在磁盘上的私钥或明文 Token 可能会被窃取。
    - **建议**：定期审计 GitHub 上的授权列表，并为 PAT 设置较短的有效期。
- **权限最小化**：
    - 使用 PAT 时，仅勾选所需的 `repo` 权限。
    - 使用 SSH 时，该密钥将拥有你账户下所有仓库的读写权限。

---

## 4. 下一步行动
请 0x01 完成上述“第三步”的 GitHub 页面操作。配置完成后，可要求我执行 `ssh -T git@github.com` 来验证连接。
