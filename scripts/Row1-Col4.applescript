-- Row1-Col4: Focus Terminal
-- Brings Terminal (or iTerm2 if that's what's running) to the front.

if application "iTerm2" is running then
	tell application "iTerm2" to activate
	say "i Term"
else
	tell application "Terminal" to activate
	say "Terminal"
end if
