-- Row2-Col2: Deny (option 2)
-- Types "2" and presses Enter — to reject Claude Code's permission prompts.

tell application "System Events"
	keystroke "2"
	delay 0.1
	key code 36
end tell
say "Denied"
