-- Row3-Col2: Git status
-- Runs git status in the default project and speaks a short summary.

property buttonId : "Row3-Col2"
property confirmAnnounce : "Git status"
property confirmEnabled : false

on confirmPress()
	if not confirmEnabled then return true
	set cacheDir to (POSIX path of (path to home folder)) & "Library/Application Support/StreamDockButtons/"
	set markerPath to cacheDir & "confirm-" & buttonId & ".marker"
	try
		set nowSec to (do shell script "date +%s") as integer
		set markerSec to (do shell script "stat -f %m " & quoted form of markerPath) as integer
		if (nowSec - markerSec) < 5 then
			do shell script "rm -f " & quoted form of markerPath
			return true
		end if
	end try
	try
		do shell script "mkdir -p " & quoted form of cacheDir & " && touch " & quoted form of markerPath
	end try
	say confirmAnnounce & ". Press again to confirm."
	return false
end confirmPress

if not my confirmPress() then return

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
