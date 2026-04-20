-- Row1-Col5: Interrupt Claude
-- Sends ESC to the frontmost app to cancel Claude's current operation.

tell application "System Events"
	key code 53
end tell
say "Interrupted"
