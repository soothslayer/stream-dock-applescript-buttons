-- Row3-Col2: Git status
-- Runs git status in the default project and speaks a summary.

set projectPath to "~/git"

try
	set result to do shell script "cd " & projectPath & " && git status --short 2>&1 | head -20"
	if result is "" then
		say "Working tree clean"
	else
		say "Changes: " & result
	end if
on error
	say "Not a git repository or git not available"
end try
