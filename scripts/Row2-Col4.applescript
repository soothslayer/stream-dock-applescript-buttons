-- Row2-Col4: Read clipboard
-- Speaks the current clipboard contents aloud.

try
	set clip to the clipboard as text
	if (length of clip) is 0 then
		say "Clipboard is empty"
	else if (length of clip) > 2000 then
		say "Clipboard has " & (length of clip) & " characters. First part: " & (text 1 thru 2000 of clip)
	else
		say clip
	end if
on error
	say "Cannot read clipboard"
end try
