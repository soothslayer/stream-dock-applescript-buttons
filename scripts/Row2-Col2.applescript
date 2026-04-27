-- Row2-Col2: Deny (option 2)
-- Types "2" + Enter to reject Claude Code's permission prompts.

property buttonId : "Row2-Col2"
property confirmAnnounce : "Deny"
property confirmEnabled : false

on confirmPress()
	if not confirmEnabled then return true
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

try
	tell application "System Events"
		keystroke "2"
		delay 0.1
		key code 36
	end tell
	say "Denied"
on error
	say "Accessibility permission needed"
end try
