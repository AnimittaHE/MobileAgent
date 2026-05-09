# MobileAgent

基于 [mobileCodexHelper](https://github.com/StarsTom/mobileCodexHelper) 的二次修改版本，让你在手机上远程使用 Claude Code 和 Codex CLI 进行 vibe coding。

> 原项目 mobileCodexHelper 是一个 Windows 桌面工具，能将本地 Codex 会话变成手机可访问的私有页面。本项目在此基础上去除了 Codex 独占限制，使其同时支持多种 AI 编程 CLI。

## 与原项目的主要差异

### 多 Provider 支持

原项目默认锁定在 **Codex-only** 模式（`CODEX_ONLY_HARDENED_MODE=true`），本版本将其解锁为多 Provider：

- **Claude Code**（通过 DeepSeek Anthropic 兼容 API 端点 `https://api.deepseek.com/anthropic`）
- **Codex**（通过原生 OpenAI/ChatGPT 认证）
- **Cursor** / **Gemini**（上游 claudecodeui 已有支持）

### 对话中切换模型

在聊天界面添加了模型选择下拉框，无需新建会话即可切换模型：

- Claude Code 支持选择 DeepSeek 各模型（如 `deepseek-v4-pro`、`deepseek-v4-flash`）
- Codex 额外添加了 `GPT-5.5` 选项
- 下拉框仅在非 Codex-only 模式下显示

### 其他改进

- Windows 项目创建时支持系统文件夹选择器
- 工作区路径校验和磁盘根目录浏览
- Codex 会话恢复失败时的自动重试（thread not found / state db missing）
- 端口冲突检测（启动脚本不再重复启动已运行的服务）

## 架构（基于原项目）

```text
手机浏览器
   ↓
Tailscale 私网 HTTPS
   ↓
本机 nginx 代理 (:8080)
   ↓
本机网页控制服务 (:3001)
   ↓
电脑上的 Claude Code / Codex 会话
```

## 快速开始

### 环境要求

- Windows 11
- Python 3.11+
- Node.js 22 LTS
- Git
- Claude Code CLI 和/或 Codex CLI
- Tailscale（推荐）

### 配置

1. 修改 `vendor/claudecodeui-1.25.2/.env`，设置 API 密钥和端点
2. Claude Code 通过 `~/.claude/settings.json` 配置 DeepSeek 代理
3. Codex 使用原生认证（`~/.codex/auth.json`）

### 启动

```powershell
powershell -ExecutionPolicy Bypass -File scripts/start-mobile-codex-stack.ps1
```

然后双击 `MobileCodexControl.exe`（或运行 `python mobile_codex_control.py`）打开桌面控制工具。

## 上游项目

- [StarsTom/mobileCodexHelper](https://github.com/StarsTom/mobileCodexHelper) — 本项目的基础框架
- [siteboon/claudecodeui](https://github.com/siteboon/claudecodeui) — 上游 Web UI（mobileCodexHelper 基于 v1.25.2）

## 许可证

继承原项目许可证。上游归属和许可证文件保留在本仓库中。
