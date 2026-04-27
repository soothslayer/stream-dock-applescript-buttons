-- Row1-Col3: Read last terminal output
-- Reads the last ~500 chars of the front Terminal (or iTerm2) tab.

property buttonId : "Row1-Col3"
property confirmAnnounce : "Read terminal output"
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

on getTerminalText()
	if application "Terminal" is running then
		try
			tell application "Terminal"
				return contents of selected tab of front window
			end tell
		end try
	end if
	if application "iTerm2" is running then
		try
			tell application "iTerm2"
				tell current window to tell current session to return contents
			end tell
		end try
	end if
	return ""
end getTerminalText

if not my confirmPress() then return

set txt to getTerminalText()
if txt is "" then
	say "No terminal window found"
	return
end if

-- Strip ANSI escape codes so they don't get spoken.
set txt to do shell script "printf '%s' " & quoted form of txt & " | perl -pe 's/\\e\\[[0-9;]*[a-zA-Z]//g; s/\\e\\][^\\a]*\\a//g'"

set txtLen to count of txt
if txtLen > 500 then
	set recent to text (txtLen - 500) thru -1 of txt
else
	set recent to txt
end if

if recent is "" then
	say "Terminal is empty"
else
	say recent
end if
