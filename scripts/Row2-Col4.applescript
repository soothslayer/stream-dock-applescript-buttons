-- Row2-Col4: Read clipboard
-- Speaks the current clipboard contents aloud.

try
	set clip to the clipboard as text
	if (length of clip) is 0 then
		say "Clipboard is empty"
	else
		say clip
	end if
on error
	say "Cannot read clipboard"
end try
