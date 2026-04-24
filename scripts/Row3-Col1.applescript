-- Row3-Col1: Activate Siri
-- Launches the Siri app, which opens the Siri panel and starts listening.
-- Requires Siri to be enabled in System Settings > Apple Intelligence & Siri.

property buttonId : "Row3-Col1"
property confirmAnnounce : "Activate Siri"

on confirmPress()
	set cacheDir to (POSIX path of (path to home folder)) & "Library/Application Support/StreamDockButtons/"
	set markerPath to cacheDir & "confirm-" & buttonId & ".marker"
	try
		set nowSec to (do shell script "date +%s") as integer
		set markerSec to (do shell script "stat -f %m " & quoted form of markerPath) as integer
		if (nowSec - markerSec) < 5 then
			do shell script "rm -f " & quoted form of markerPath
			return true
		end if
	end try
	try
		do shell script "mkdir -p " & quoted form of cacheDir & " && touch " & quoted form of markerPath
	end try
	say confirmAnnounce & ". Press again to confirm."
	return false
end confirmPress

if not my confirmPress() then return

-- Click the Siri menu bar icon to force voice listening mode.
-- "tell application Siri to activate" respects Type to Siri and opens a text field;
-- clicking the menu bar item always starts the microphone, like pressing the Siri key.
set siriStarted to false
try
	tell application "System Events"
		tell process "SystemUIServer"
			set siriItems to (menu bar items of menu bar 1 whose description is "Siri")
			if (count of siriItems) > 0 then
				click (item 1 of siriItems)
				set siriStarted to true
			end if
		end tell
	end tell
end try

if not siriStarted then
	-- Fallback: simulate the configured Siri keyboard shortcut
	try
		tell application "System Events"
			key code 49 using {command down}
		end tell
		set siriStarted to true
	end try
end if

if not siriStarted then
	say "Could not activate Siri. Make sure Siri is enabled and shown in the menu bar."
end if
