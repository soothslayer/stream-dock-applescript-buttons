-- Row1-Col5: Launch Siri

property buttonId : "Row1-Col5"
property confirmAnnounce : "Launch Siri"

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

-- Press fn (Globe) + Space to activate Siri voice listening.
-- AppleScript's System Events doesn't support the fn modifier, so we
-- post the key event via CGEvent with the SecondaryFn flag set.
try
	do shell script "/usr/bin/python3 <<'PY'
from Quartz import CGEventCreateKeyboardEvent, CGEventPost, CGEventSetFlags, kCGHIDEventTap, kCGEventFlagMaskSecondaryFn
import time
SPACE = 49
down = CGEventCreateKeyboardEvent(None, SPACE, True)
up = CGEventCreateKeyboardEvent(None, SPACE, False)
CGEventSetFlags(down, kCGEventFlagMaskSecondaryFn)
CGEventSetFlags(up, kCGEventFlagMaskSecondaryFn)
CGEventPost(kCGHIDEventTap, down)
time.sleep(0.05)
CGEventPost(kCGHIDEventTap, up)
PY"
on error
	say "Could not launch Siri."
end try
