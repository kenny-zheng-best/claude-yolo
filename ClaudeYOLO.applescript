-- Claude YOLO
-- You Only Live Once - 一键启动 Claude Code bypass permissions 模式

on run
	-- 获取 App 内部的 launch 脚本路径
	set appPath to POSIX path of (path to me)
	set launchScript to quoted form of (appPath & "Contents/Resources/launch-claude.sh")

	tell application "Terminal"
		activate
		do script "cd $HOME && " & launchScript
	end tell
end run
