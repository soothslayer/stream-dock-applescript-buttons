-- Row3-Col3: Time + Claude status
-- Says the current time and whether Claude Code is running.

property buttonId : "Row3-Col3"
property confirmAnnounce : "Time and Claude status"

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

set t to do shell script "date +'%-l:%M %p'"
set claudeCount to do shell script "pgrep -xc claude || true"
if claudeCount is "" or claudeCount is "0" then
	say "Time is " & t & ". Claude is not running."
else if claudeCount is "1" then
	say "Time is " & t & ". Claude is running."
else
	say "Time is " & t & ". " & claudeCount & " Claude processes are running."
end if
