-- Row1-Col5: Interrupt Claude
-- Sends ESC to the frontmost app to cancel Claude's current operation.
-- Requires Accessibility permission for Stream Deck / the .app.

try
	tell application "System Events" to key code 53
	say "Interrupted"
on error
	say "Accessibility permission needed. See read me."
end try
