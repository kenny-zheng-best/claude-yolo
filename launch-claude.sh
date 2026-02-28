#!/bin/bash
# Claude YOLO - 一键启动 Claude Code bypass permissions 模式

# 查找 claude 二进制
CLAUDE_BIN=""
for path in \
    "$HOME/.local/bin/claude" \
    "/usr/local/bin/claude" \
    "$(which claude 2>/dev/null)"; do
    if [ -x "$path" ] 2>/dev/null; then
        CLAUDE_BIN="$path"
        break
    fi
done

if [ -z "$CLAUDE_BIN" ]; then
    echo ""
    echo "  ⚡ Claude YOLO"
    echo ""
    echo "  Claude Code 未安装。请先安装："
    echo ""
    echo "    npm install -g @anthropic-ai/claude-code"
    echo ""
    echo "  安装完成后重新打开此 App。"
    echo ""
    read -p "  按回车关闭..."
    exit 1
fi

# 用 expect 启动并自动跳过 trust 确认
expect -c "
set rows [exec tput lines]
set cols [exec tput cols]
stty rows \$rows columns \$cols

spawn $CLAUDE_BIN --dangerously-skip-permissions

expect {
    -timeout 10
    \"*proceed*\" { send \"\r\" }
    \"*trust*\"   { send \"\r\" }
    \"*Yes*\"     { send \"\r\" }
    timeout       {}
}

interact
"
