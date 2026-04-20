-- buttons/Row2-Col5.applescript
-- Thin wrapper: downloads and runs scripts/Row2-Col5.applescript from GitHub.
-- Assign this (compiled as .app) to Stream Deck button at row 2, column 5.
-- To change what this button does, edit scripts/Row2-Col5.applescript in the repo.

set scriptName to "Row2-Col5.applescript"
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
	say "Button " & "2" & " " & "5" & " not available. No internet and no cached script."
	return
end try

try
	run script (POSIX file cachePath)
on error errMsg
	say "Button " & "2" & " " & "5" & " error."
end try
