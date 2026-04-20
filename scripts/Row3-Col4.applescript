-- Row3-Col4: Emergency kill Claude
-- Force-stops the Claude CLI (exact-name match only — won't touch claude-code-voice etc).

try
	set killed to do shell script "pkill -x claude && echo yes || echo no"
	if killed is "yes" then
		say "Claude stopped"
	else
		say "Claude was not running"
	end if
on error
	say "Could not stop Claude"
end try
