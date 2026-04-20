-- Row2-Col1: Approve (option 1)
-- Types "1" and presses Enter — for Claude Code's numbered permission prompts.

tell application "System Events"
	keystroke "1"
	delay 0.1
	key code 36
end tell
say "Approved"
