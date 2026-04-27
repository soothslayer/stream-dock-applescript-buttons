-- Row1-Col2: Describe Screen
-- Takes a screenshot and asks Claude to describe it aloud.
--
-- Prerequisites:
--   - `jq` installed: brew install jq
--   - Anthropic API key stored in Keychain:
--       security add-generic-password -a "$USER" -s ANTHROPIC_API_KEY -w "sk-ant-..."
--   - Screen Recording permission granted to whatever runs this (Stream Deck / the .app)

property buttonId : "Row1-Col2"
property confirmAnnounce : "Describe screen"
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

on getAnthropicKey()
	try
		return do shell script "security find-generic-password -a \"$USER\" -s ANTHROPIC_API_KEY -w 2>/dev/null"
	on error
		return ""
	end try
end getAnthropicKey

if not my confirmPress() then return

set apiKey to getAnthropicKey()
if apiKey is "" then
	say "API key not found in keychain. See read me for setup."
	return
end if

set hasJq to do shell script "command -v jq > /dev/null && echo yes || echo no"
if hasJq is "no" then
	say "jq is not installed. Run brew install jq."
	return
end if

say "Describing screen"

set shellCmd to "set -e
export ANTHROPIC_API_KEY=" & quoted form of apiKey & "
IMG=/tmp/sd-screen.png
screencapture -x \"$IMG\"
B64=$(base64 -b 0 -i \"$IMG\")
PAYLOAD=$(jq -n --arg b64 \"$B64\" '{model:\"claude-sonnet-4-6\",max_tokens:400,messages:[{role:\"user\",content:[{type:\"image\",source:{type:\"base64\",media_type:\"image/png\",data:$b64}},{type:\"text\",text:\"Describe what is on this screen concisely for a blind user. Focus on the active window, visible text, errors, and anything needing attention. 3 sentences max.\"}]}]}')
for i in 1 2; do
  RESP=$(curl -s --max-time 20 https://api.anthropic.com/v1/messages \\
    -H \"x-api-key: $ANTHROPIC_API_KEY\" \\
    -H \"anthropic-version: 2023-06-01\" \\
    -H \"content-type: application/json\" \\
    -d \"$PAYLOAD\")
  TEXT=$(printf '%s' \"$RESP\" | jq -r '.content[0].text // empty')
  if [ -n \"$TEXT\" ]; then
    printf '%s' \"$TEXT\"
    exit 0
  fi
  sleep 1
done
echo \"Claude API did not respond. $(printf '%s' \"$RESP\" | jq -r '.error.message // \"unknown error\"')\" >&2
exit 1"

try
	set response to do shell script shellCmd
	say response
on error errMsg
	say "Could not describe screen. " & errMsg
end try
