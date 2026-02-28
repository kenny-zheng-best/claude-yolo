#!/bin/bash
# Claude YOLO - 一键启动 Claude Code bypass permissions 模式

clear
echo ""
echo "  ⚡ Claude YOLO"
echo "  ─────────────────────────────"
echo ""

# ===== 1. 检查 Node.js =====
NODE_BIN=""
for path in \
    "/opt/homebrew/bin/node" \
    "/usr/local/bin/node"; do
    if [ -x "$path" ]; then
        NODE_BIN="$path"
        break
    fi
done
if [ -z "$NODE_BIN" ]; then
    NODE_BIN="$(command -v node 2>/dev/null)"
fi

if [ -z "$NODE_BIN" ] || [ ! -x "$NODE_BIN" ]; then
    echo "  ❌ Node.js is not installed."
    echo ""
    echo "  Claude Code requires Node.js to run."
    echo "  Opening the Node.js download page for you..."
    echo ""
    open "https://nodejs.org/"
    echo "  After installing Node.js, reopen Claude YOLO."
    echo ""
    read -p "  Press Enter to close..."
    exit 1
fi

# ===== 2. 检查 Claude Code =====
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
if [ -z "$CLAUDE_BIN" ]; then
    CLAUDE_BIN="$(command -v claude 2>/dev/null)"
fi

if [ -z "$CLAUDE_BIN" ] || [ ! -x "$CLAUDE_BIN" ]; then
    echo "  ❌ Claude Code is not installed."
    echo ""
    echo "  Installing Claude Code for you..."
    echo ""

    # 查找 npm
    NPM_BIN=""
    for path in \
        "/opt/homebrew/bin/npm" \
        "/usr/local/bin/npm"; do
        if [ -x "$path" ]; then
            NPM_BIN="$path"
            break
        fi
    done
    if [ -z "$NPM_BIN" ]; then
        NPM_BIN="$(command -v npm 2>/dev/null)"
    fi

    if [ -z "$NPM_BIN" ]; then
        echo "  ❌ npm not found. Please reinstall Node.js from:"
        echo "     https://nodejs.org/"
        echo ""
        open "https://nodejs.org/"
        read -p "  Press Enter to close..."
        exit 1
    fi

    "$NPM_BIN" install -g @anthropic-ai/claude-code 2>&1
    echo ""

    # 重新搜索
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
    if [ -z "$CLAUDE_BIN" ]; then
        CLAUDE_BIN="$(command -v claude 2>/dev/null)"
    fi

    if [ -z "$CLAUDE_BIN" ] || [ ! -x "$CLAUDE_BIN" ]; then
        echo "  ❌ Installation failed. Please install manually:"
        echo ""
        echo "     npm install -g @anthropic-ai/claude-code"
        echo ""
        read -p "  Press Enter to close..."
        exit 1
    fi

    echo "  ✅ Claude Code installed successfully!"
    echo ""
fi

echo "  ✅ Launching Claude Code (YOLO mode)..."
echo ""

# ===== 3. 检查 expect 是否可用 =====
if command -v expect &>/dev/null; then
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
else
    # 没有 expect，直接启动（用户需要手动确认 trust）
    exec "$CLAUDE_BIN" --dangerously-skip-permissions
fi
