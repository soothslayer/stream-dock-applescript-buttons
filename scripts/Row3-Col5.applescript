-- Row3-Col5: Toggle VoiceOver Trackpad Commander

property buttonId : "Row3-Col5"
property confirmAnnounce : "Toggle Trackpad Commander"

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

-- Flip SCRTrackpadCommanderEnabled in com.apple.VoiceOver4/default and restart
-- VoiceOver so the change takes effect.
try
	set currentVal to do shell script "defaults read com.apple.VoiceOver4/default SCRTrackpadCommanderEnabled 2>/dev/null || echo 0"
on error
	set currentVal to "0"
end try

if currentVal is "1" then
	set newVal to "0"
	set spoken to "Trackpad Commander off"
else
	set newVal to "1"
	set spoken to "Trackpad Commander on"
end if

do shell script "defaults write com.apple.VoiceOver4/default SCRTrackpadCommanderEnabled -int " & newVal

-- Restart VoiceOver to apply. Killing VoiceOver and relaunching preserves
-- the user's running state.
try
	set voIsRunning to false
	try
		tell application "System Events"
			if (exists process "VoiceOver") then set voIsRunning to true
		end tell
	end try

	if voIsRunning then
		set spoken to "Turning VoiceOver Off"
		do shell script "killall VoiceOver 2>/dev/null; sleep 0.5; open -a VoiceOver"
	else
		set spoken to "Turning VoiceOver On"
		do shell script "open -a VoiceOver"
	end if
on error
	say "Could not restart VoiceOver."
	return
end try

say spoken
