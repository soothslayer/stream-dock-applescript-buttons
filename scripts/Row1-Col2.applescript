-- Row1-Col2: Describe Screen
-- Takes a screenshot and asks Claude to describe it aloud.
-- Requires ANTHROPIC_API_KEY in shell env and `jq` installed (brew install jq).

say "Describing screen"
try
	set response to do shell script "IMG=/tmp/sd-screen.png; screencapture -x $IMG; B64=$(base64 -b 0 -i $IMG); PAYLOAD=$(jq -n --arg b64 \"$B64\" '{model:\"claude-sonnet-4-6\",max_tokens:400,messages:[{role:\"user\",content:[{type:\"image\",source:{type:\"base64\",media_type:\"image/png\",data:$b64}},{type:\"text\",text:\"Describe what is on this screen concisely for a blind user. Focus on the active window, visible text, errors, and anything needing attention. 3 sentences max.\"}]}]}'); source ~/.zshrc 2>/dev/null; curl -s https://api.anthropic.com/v1/messages -H \"x-api-key: $ANTHROPIC_API_KEY\" -H \"anthropic-version: 2023-06-01\" -H \"content-type: application/json\" -d \"$PAYLOAD\" | jq -r '.content[0].text'"
	say response
on error errMsg
	say "Could not describe screen. " & errMsg
end try
