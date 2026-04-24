-- Row1-Col4: Focus Terminal
-- Brings Terminal (or iTerm2 if that's what's running) to the front.

property buttonId : "Row1-Col4"
property confirmAnnounce : "Focus terminal"

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

if application "iTerm2" is running then
	tell application "iTerm2" to activate
	say "i Term"
else
	tell application "Terminal" to activate
	say "Terminal"
end if
