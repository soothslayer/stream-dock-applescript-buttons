-- Row1-Col3: Read last terminal output
-- Reads the last ~500 chars of the front Terminal (or iTerm2) tab.

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
