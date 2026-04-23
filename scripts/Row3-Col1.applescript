-- Row3-Col1: Activate Siri
-- Launches the Siri app, which opens the Siri panel and starts listening.
-- Requires Siri to be enabled in System Settings > Apple Intelligence & Siri.

try
	tell application "Siri" to activate
on error errMsg
	say "Could not activate Siri. " & errMsg
end try
