-- Row2-Col3: Enter / submit
-- Presses Return in the frontmost app.

try
	tell application "System Events" to key code 36
on error
	say "Accessibility permission needed"
end try
