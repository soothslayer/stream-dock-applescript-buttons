-- Row3-Col3: Time + Claude status
-- Says the current time and whether Claude Code is running.

set t to do shell script "date +'%-l:%M %p'"
set isRunning to do shell script "pgrep -f 'claude' > /dev/null && echo yes || echo no"
if isRunning is "yes" then
	say "Time is " & t & ". Claude is running."
else
	say "Time is " & t & ". Claude is not running."
end if
