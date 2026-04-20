-- Row2-Col1: Approve (option 1)
-- Types "1" + Enter to accept Claude Code's numbered permission prompts.

try
	tell application "System Events"
		keystroke "1"
		delay 0.1
		key code 36
	end tell
	say "Approved"
on error
	say "Accessibility permission needed"
end try
