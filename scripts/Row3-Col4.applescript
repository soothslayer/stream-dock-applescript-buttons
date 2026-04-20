-- Row3-Col4: Emergency kill Claude
-- Force-stops any running Claude Code processes.

try
	do shell script "pkill -f 'claude' || true"
	say "Claude stopped"
on error
	say "Could not stop Claude"
end try
