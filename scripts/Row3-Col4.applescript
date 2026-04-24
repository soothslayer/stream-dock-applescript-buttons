-- Row3-Col4: Emergency kill Claude
-- Force-stops the Claude CLI (exact-name match only — won't touch claude-code-voice etc).

property buttonId : "Row3-Col4"
property confirmAnnounce : "Kill Claude"

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
	set killed to do shell script "pkill -x claude && echo yes || echo no"
	if killed is "yes" then
		say "Claude stopped"
	else
		say "Claude was not running"
	end if
on error
	say "Could not stop Claude"
end try
