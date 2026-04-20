-- Row1-Col3: Read last terminal output
-- Reads the last ~500 characters of the frontmost Terminal tab.

try
	tell application "Terminal"
		set txt to contents of selected tab of front window
	end tell
	set txtLen to count of txt
	if txtLen > 500 then
		set recent to text (txtLen - 500) thru -1 of txt
	else
		set recent to txt
	end if
	say recent
on error
	say "No terminal output to read"
end try
