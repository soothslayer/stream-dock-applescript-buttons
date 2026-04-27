-- Row1-Col5: Launch Siri

property buttonId : "Row1-Col5"
property confirmAnnounce : "Launch Siri"
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

-- Press Control + Space to activate Siri voice listening.
try
	tell application "System Events" to key code 49 using control down
on error
	say "Could not launch Siri."
end try
