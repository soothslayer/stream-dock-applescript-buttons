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

try
	tell application "Siri" to activate
on error errMsg
	say "Could not activate Siri. " & errMsg
end try
