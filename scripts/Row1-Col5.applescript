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

-- Press fn (Globe) + Space to activate Siri voice listening.
-- AppleScript's System Events doesn't support the fn modifier, so we
-- post the key event via CGEvent with the SecondaryFn flag set.
on sendFnSpace()
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
end sendFnSpace

on logError(msg)
	set cacheDir to (POSIX path of (path to home folder)) & "Library/Application Support/StreamDockButtons/"
	set logPath to cacheDir & "Row1-Col5.error.log"
	try
		do shell script "mkdir -p " & quoted form of cacheDir & " && printf '%s\\n' " & quoted form of ((short date string of (current date)) & " " & (time string of (current date)) & " " & msg) & " >> " & quoted form of logPath
	end try
end logError

try
	sendFnSpace()
on error errMsg
	if errMsg contains "Quartz" or errMsg contains "ModuleNotFoundError" then
		my logError("Quartz missing, installing pyobjc: " & errMsg)
		say "Installing Siri helper. This will take a minute."
		try
			do shell script "/usr/bin/python3 -m pip install --user --break-system-packages --quiet pyobjc-framework-Quartz 2>&1 || /usr/bin/python3 -m pip install --user --quiet pyobjc-framework-Quartz 2>&1"
		on error installErr
			my logError("Install failed: " & installErr)
			say "Could not install Siri helper. " & installErr
			return
		end try
		try
			sendFnSpace()
		on error retryErr
			my logError("Retry failed: " & retryErr)
			say "Install succeeded but Siri still failed. " & retryErr
		end try
	else
		my logError("Siri failed: " & errMsg)
		say "Could not launch Siri. " & errMsg
	end if
end try
