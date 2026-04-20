-- Row3-Col1: Toggle VoiceOver
-- Cmd+F5 — standard macOS shortcut.
-- May require "Use F1, F2, etc. keys as standard function keys" OR Fn held.
-- If this doesn't work, enable VoiceOver via System Settings > Accessibility > VoiceOver.

try
	tell application "System Events"
		key code 96 using {command down}
	end tell
on error
	say "Could not toggle VoiceOver"
end try
