-- Row2-Col1: Run the "Wake Claudette" Siri shortcut.

property buttonId : "Row2-Col1"
property shortcutName : "Wake Claudette"
property confirmAnnounce : "Wake Claudette"

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

say "Running " & shortcutName
try
	do shell script "shortcuts run " & quoted form of shortcutName
on error errMsg
	say "Shortcut failed: " & errMsg
end try
