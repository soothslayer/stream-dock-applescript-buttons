-- Row2-Col4: Read clipboard
-- Speaks the current clipboard contents aloud.

property buttonId : "Row2-Col4"
property confirmAnnounce : "Read clipboard"
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
	set clip to the clipboard as text
	if (length of clip) is 0 then
		say "Clipboard is empty"
	else if (length of clip) > 2000 then
		say "Clipboard has " & (length of clip) & " characters. First part: " & (text 1 thru 2000 of clip)
	else
		say clip
	end if
on error
	say "Cannot read clipboard"
end try
