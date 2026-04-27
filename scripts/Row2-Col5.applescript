-- Row2-Col5: Copy last Claude response
-- Grabs recent Terminal text, strips ANSI codes, puts it on the clipboard.

property buttonId : "Row2-Col5"
property confirmAnnounce : "Copy last response"
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

set cleaned to do shell script "printf '%s' " & quoted form of txt & " | perl -pe 's/\\e\\[[0-9;]*[a-zA-Z]//g; s/\\e\\][^\\a]*\\a//g'"

set txtLen to count of cleaned
if txtLen > 4000 then
	set recent to text (txtLen - 4000) thru -1 of cleaned
else
	set recent to cleaned
end if

set the clipboard to recent
say "Copied last response"
