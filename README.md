# Claude YOLO

**You Only Live Once** — 双击即可启动 Claude Code YOLO 模式的 macOS 应用。

无需打开终端，无需记命令。双击打开，自动搞定一切。

## 下载安装

前往 [Releases](https://github.com/kenny-zheng-best/claude-yolo/releases/latest) 页面，下载最新的 **Claude-YOLO.dmg**，打开后将应用拖入 Applications 文件夹即可。

## 功能

- 自动检测 Node.js，未安装则引导安装
- 自动安装 Claude Code CLI（如果还没装）
- 一键启动 `claude --dangerously-skip-permissions` 模式
- 自动跳过信任确认（如果系统有 `expect`）
- 支持 Intel 和 Apple Silicon Mac

## 系统要求

- macOS 10.6+
- Node.js（应用会引导你安装）
- Anthropic API Key 或 Claude Pro/Max 订阅

## 截图

打开 DMG 后拖入 Applications 即可：

```
┌──────────────────────────────┐
│                              │
│   [Claude YOLO]  →  [Apps]   │
│                              │
└──────────────────────────────┘
```

## 工作原理

Claude YOLO 是一个 AppleScript 应用，启动后会在终端中运行 `launch-claude.sh` 脚本：

1. 检查 Node.js 是否已安装
2. 检查 Claude Code CLI 是否已安装，没有则自动 `npm install -g @anthropic-ai/claude-code`
3. 以 `--dangerously-skip-permissions` 模式启动 Claude Code

## License

MIT
