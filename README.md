# stream-dock-applescript-buttons

Remotely-updatable AppleScript actions for a 16-button (4×4) Stream Deck.

## How it works

Two folders, one-to-one mapping:

- **`buttons/`** — 16 thin wrapper scripts. Installed once onto the Mac and assigned to Stream Deck buttons. These never change.
- **`scripts/`** — 16 real scripts. Edit these on GitHub any time to change what a button does. The next button press downloads and runs the new version.

Each button wrapper:

1. Downloads its matching file from `scripts/` on GitHub (5s timeout).
2. Caches it in `~/Library/Application Support/StreamDockButtons/`.
3. Runs it.

If offline, the last cached version runs instead. If there's no cache and no network, the button speaks an audible error (important — this was built for a blind user).

## Naming

`Row{1-4}-Col{1-4}.applescript` maps directly to the physical grid:

```
Row1-Col1  Row1-Col2  Row1-Col3  Row1-Col4
Row2-Col1  Row2-Col2  Row2-Col3  Row2-Col4
Row3-Col1  Row3-Col2  Row3-Col3  Row3-Col4
Row4-Col1  Row4-Col2  Row4-Col3  Row4-Col4
```

Top-left is `Row1-Col1`, bottom-right is `Row4-Col4`.

## One-time setup (on the friend's Mac)

```bash
curl -fsSL https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/main/install.sh | bash
```

This compiles all 16 wrappers into `.app` bundles in `~/StreamDockButtons/`.

Then in the Stream Deck app, for each of the 16 buttons:

1. Drag **System → Open** onto the button.
2. Set the File to the matching `.app` in `~/StreamDockButtons/` (e.g. top-left button → `Row1-Col1.app`).
3. Optionally set a title/icon.

Do this once. The buttons now point at local apps that never need to change.

## Updating a button remotely

Edit the matching file in `scripts/` on GitHub (web UI works). Commit to `main`. The next time the button is pressed, the new version downloads and runs.

Example: to make the top-left button launch Safari, edit `scripts/Row1-Col1.applescript`:

```applescript
tell application "Safari" to activate
```

Commit. Press the button. Safari opens.

## Testing

After install, press each button — it should speak its row and column (the default placeholder scripts). That confirms the wrapper is wired correctly. Then replace the placeholders with real functionality.

## Troubleshooting

- **Button does nothing**: Stream Deck may be blocked by macOS privacy on first run. Open the `.app` in Finder once (right-click → Open) to accept the Gatekeeper prompt.
- **`run script` fails silently**: AppleScript may need Automation permissions for the target app. System Settings → Privacy & Security → Automation.
- **Cache won't refresh**: delete `~/Library/Application Support/StreamDockButtons/` and press the button again.
