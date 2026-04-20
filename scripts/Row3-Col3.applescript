-- Row3-Col3: Time + Claude status
-- Says the current time and whether Claude Code is running.

set t to do shell script "date +'%-l:%M %p'"
set claudeCount to do shell script "pgrep -xc claude || true"
if claudeCount is "" or claudeCount is "0" then
	say "Time is " & t & ". Claude is not running."
else if claudeCount is "1" then
	say "Time is " & t & ". Claude is running."
else
	say "Time is " & t & ". " & claudeCount & " Claude processes are running."
end if
