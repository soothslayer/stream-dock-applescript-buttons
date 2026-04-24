-- Row1-Col5: Interrupt Claude
-- Sends ESC to the frontmost app to cancel Claude's current operation.
-- Requires Accessibility permission for Stream Deck / the .app.

property buttonId : "Row1-Col5"
property confirmAnnounce : "Interrupt Claude"

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

try
	tell application "System Events" to key code 53
	say "Interrupted"
on error
	say "Accessibility permission needed. See read me."
end try
