-- Claude YOLO
-- You Only Live Once - 一键启动 Claude Code bypass permissions 模式
-- 使用 expect 自动跳过 trust folder 确认

on run
	set launchScript to quoted form of "/Users/kennyzheng/Documents/coding/Claude code start/launch-claude.sh"
	tell application "Terminal"
		activate
		do script "cd /Users/kennyzheng && " & launchScript
	end tell
end run
