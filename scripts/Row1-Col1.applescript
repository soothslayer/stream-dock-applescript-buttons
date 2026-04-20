-- Row1-Col1: Start Claude Code
-- Opens Terminal, cds to the default project, launches Claude Code.

set projectPath to "~/git"

tell application "Terminal"
	activate
	do script "cd " & projectPath & " && claude --dangerously-skip-permissions"
end tell
delay 1
say "Claude Code starting"
