-- buttons/Row3-Col5.applescript
-- Thin wrapper: downloads and runs scripts/Row3-Col5.applescript from GitHub.
-- Assign this (compiled as .app) to Stream Deck button at row 3, column 5.
-- To change what this button does, edit scripts/Row3-Col5.applescript in the repo.

set scriptName to "Row3-Col5.applescript"
set repoURL to "https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/main/scripts/"
set cacheDir to (POSIX path of (path to home folder)) & "Library/Application Support/StreamDockButtons/"
set cachePath to cacheDir & scriptName

do shell script "mkdir -p " & quoted form of cacheDir

try
	do shell script "curl -fsSL --max-time 5 " & quoted form of (repoURL & scriptName) & " -o " & quoted form of (cachePath & ".new")
	do shell script "mv " & quoted form of (cachePath & ".new") & " " & quoted form of cachePath
end try

try
	do shell script "test -f " & quoted form of cachePath
on error
	say "Button " & "3" & " " & "5" & " not available. No internet and no cached script."
	return
end try

try
	run script (POSIX file cachePath)
on error errMsg
	say "Button " & "3" & " " & "5" & " error."
end try
