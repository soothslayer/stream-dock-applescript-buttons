-- Row3-Col5: Speak button map
-- Reads out what each button on the Stream Deck does.

property buttonId : "Row3-Col5"
property confirmAnnounce : "Button map"

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

say "Row 1, top: Start Claude, Describe screen, Read output, Focus terminal, Interrupt."
say "Row 2, middle: Approve, Deny, Enter, Read clipboard, Copy response."
say "Row 3, bottom: Activate Siri, Git status, Time, Kill Claude, Help."
