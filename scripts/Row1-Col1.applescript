-- Barge-in: Immediately stop Claudette's speech playback
-- Touch the interrupt file that voicemode's audio player checks

do shell script "touch /tmp/voicemode-interrupt"
