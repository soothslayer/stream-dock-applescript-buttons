-- Row2-Col5: Copy last Claude response
-- Grabs the recent Terminal output and puts it on the clipboard.

try
	tell application "Terminal"
		set txt to contents of selected tab of front window
	end tell
	set txtLen to count of txt
	if txtLen > 2000 then
		set recent to text (txtLen - 2000) thru -1 of txt
	else
		set recent to txt
	end if
	set the clipboard to recent
	say "Copied last response"
on error
	say "Could not copy terminal output"
end try
