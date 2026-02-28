#!/bin/bash
# Claude YOLO - 一键启动 Claude Code bypass permissions 模式

# 查找 claude 二进制
CLAUDE_BIN=""
for path in \
    "$HOME/.local/bin/claude" \
    "/usr/local/bin/claude" \
    "/opt/homebrew/bin/claude"; do
    if [ -x "$path" ]; then
        CLAUDE_BIN="$path"
        break
    fi
done

# 如果上面没找到，尝试 PATH
if [ -z "$CLAUDE_BIN" ]; then
    CLAUDE_BIN="$(command -v claude 2>/dev/null)"
fi

if [ -z "$CLAUDE_BIN" ] || [ ! -x "$CLAUDE_BIN" ]; then
    echo ""
    echo "  ⚡ Claude YOLO"
    echo ""
    echo "  Claude Code is not installed. Please install it first:"
    echo ""
    echo "    npm install -g @anthropic-ai/claude-code"
    echo ""
    echo "  Then reopen this app."
    echo ""
    read -p "  Press Enter to close..."
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
