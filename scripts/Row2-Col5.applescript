-- Row2-Col5: Copy last Claude response
-- Grabs recent Terminal text, strips ANSI codes, puts it on the clipboard.

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

set cleaned to do shell script "printf '%s' " & quoted form of txt & " | perl -pe 's/\\e\\[[0-9;]*[a-zA-Z]//g; s/\\e\\][^\\a]*\\a//g'"

set txtLen to count of cleaned
if txtLen > 4000 then
	set recent to text (txtLen - 4000) thru -1 of cleaned
else
	set recent to cleaned
end if

set the clipboard to recent
say "Copied last response"
