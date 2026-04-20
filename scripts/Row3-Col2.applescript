-- Row3-Col2: Git status
-- Runs git status in the default project and speaks a short summary.

set projectPath to "~/git"

try
	set inRepo to do shell script "cd " & projectPath & " && git rev-parse --is-inside-work-tree 2>/dev/null || echo no"
	if inRepo is "no" then
		say projectPath & " is not a git repository"
		return
	end if
	set branchName to do shell script "cd " & projectPath & " && git rev-parse --abbrev-ref HEAD 2>/dev/null"
	set changes to do shell script "cd " & projectPath & " && git status --short 2>&1 | head -10"
	if changes is "" then
		say "On branch " & branchName & ". Working tree clean."
	else
		set changeCount to do shell script "cd " & projectPath & " && git status --short | wc -l | tr -d ' '"
		say "On branch " & branchName & ". " & changeCount & " changed files."
	end if
on error errMsg
	say "Git status failed. " & errMsg
end try
