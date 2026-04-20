-- Row1-Col1: Start Claude Code
-- Opens Terminal, cds to the default project, launches Claude Code.
-- If Claude is already running, just brings Terminal to front.

set projectPath to "~/git"

set alreadyRunning to (do shell script "pgrep -x claude > /dev/null && echo yes || echo no")
if alreadyRunning is "yes" then
	tell application "Terminal" to activate
	say "Claude is already running"
	return
end if

tell application "Terminal"
	activate
	do script "cd " & projectPath & " && claude --dangerously-skip-permissions"
end tell
delay 1
say "Claude Code starting"
