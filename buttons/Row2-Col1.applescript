-- buttons/Row2-Col1.applescript
-- Thin wrapper: downloads and runs scripts/Row2-Col1.applescript from GitHub.
-- Assign this (compiled as .app) to Stream Deck button at row 2, column 1.
-- To change what this button does, edit scripts/Row2-Col1.applescript in the repo.

set scriptName to "Row2-Col1.applescript"
set repoURL to "https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/main/scripts/"
set cacheDir to (POSIX path of (path to home folder)) & "Library/Application Support/StreamDockButtons/"
set cachePath to cacheDir & scriptName

do shell script "mkdir -p " & quoted form of cacheDir

set fetched to false
try
	do shell script "curl -fsSL --max-time 5 " & quoted form of (repoURL & scriptName) & " -o " & quoted form of (cachePath & ".new")
	do shell script "mv " & quoted form of (cachePath & ".new") & " " & quoted form of cachePath
	set fetched to true
end try

try
	do shell script "test -f " & quoted form of cachePath
on error
	say "Button " & "2" & " " & "1" & " not available. No internet and no cached script."
	return
end try

try
	run script (POSIX file cachePath)
on error errMsg
	say "Button " & "2" & " " & "1" & " error."
end try
