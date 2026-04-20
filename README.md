# stream-dock-applescript-buttons

Remotely-updatable AppleScript actions for a 15-button (3 rows × 5 columns) Stream Deck. Built for a blind user coding with Claude Code in voice mode — buttons handle the things that are hard to do with voice (permission prompts, interrupts, screen description, status).

## Repo structure

```
stream-dock-applescript-buttons/
├── buttons/              # 15 thin wrappers — installed once, assigned to buttons
│   └── RowN-ColN.applescript
├── scripts/              # 15 real scripts — edit these remotely to change behavior
│   └── RowN-ColN.applescript
├── install.sh            # one-shot: clones repo, compiles buttons → ~/StreamDockButtons/
├── README.md
└── .gitignore
```

### How it works

Two folders, one-to-one mapping by filename:

- **`buttons/`** — 15 thin wrapper scripts. Installed once onto the Mac and assigned to Stream Deck buttons. These never change.
- **`scripts/`** — 15 real scripts. Edit these on GitHub any time to change what a button does. The next button press downloads and runs the new version.

Each button wrapper:

1. Downloads its matching file from `scripts/` on GitHub (5s timeout).
2. Caches it in `~/Library/Application Support/StreamDockButtons/`.
3. Runs it via `run script`.

If offline, the last cached version runs. If there's no cache and no network, the button speaks an audible error.

## Grid layout

`Row{1-3}-Col{1-5}.applescript` maps directly to the physical grid:

```
Row1-Col1  Row1-Col2  Row1-Col3  Row1-Col4  Row1-Col5
Row2-Col1  Row2-Col2  Row2-Col3  Row2-Col4  Row2-Col5
Row3-Col1  Row3-Col2  Row3-Col3  Row3-Col4  Row3-Col5
```

## Button map (current `scripts/` contents)

Corners are tactile landmarks — easy to find without sight.

| | Col1 | Col2 | Col3 | Col4 | Col5 |
|---|---|---|---|---|---|
| **Row1** | Start Claude Code | Describe screen | Read last output | Focus Terminal | Interrupt (ESC) |
| **Row2** | Approve (1+Enter) | Deny (2+Enter) | Enter | Read clipboard | Copy last response |
| **Row3** | Toggle VoiceOver | Git status | Time + Claude status | Kill Claude | Speak button map |

Press `Row3-Col5` (bottom-right) any time to hear the whole map read aloud.

## Prerequisites

| Requirement | Needed for | How to install / enable |
|---|---|---|
| `git` | `install.sh` | Usually preinstalled; `xcode-select --install` otherwise |
| `curl` | All buttons (fetching scripts) | Preinstalled on macOS |
| `jq` | `Row1-Col2` (Describe screen) | `brew install jq` |
| Anthropic API key in Keychain | `Row1-Col2` (Describe screen) | See below |
| Accessibility permission | All System Events buttons (Row1-Col5, Row2-*, Row3-Col1) | See below |
| Automation permission (Terminal) | Reading output / copying response | See below |
| Screen Recording permission | `Row1-Col2` (Describe screen) | System Settings → Privacy & Security → Screen Recording |

### Storing the Anthropic API key in Keychain

`Row1-Col2` (Describe screen) calls the Claude API. AppleScript runs with a minimal shell environment, so env vars from `.zshrc` are not visible. The key lives in Keychain instead:

```bash
security add-generic-password -a "$USER" -s ANTHROPIC_API_KEY -w "sk-ant-..."
```

To update later: add `-U` to overwrite. To remove: `security delete-generic-password -a "$USER" -s ANTHROPIC_API_KEY`.

### Granting macOS permissions

First time a button tries to press keys or read Terminal output, macOS will prompt. If you miss the prompt, grant manually:

- **Accessibility**: System Settings → Privacy & Security → Accessibility → enable each `RowN-ColN.app` (or enable the Stream Deck app itself, whichever is invoking the scripts).
- **Automation**: System Settings → Privacy & Security → Automation → allow the buttons to control `Terminal`, `iTerm2`, `System Events`.
- **Screen Recording**: required for `Row1-Col2` — without it, `screencapture` produces a black image.

## One-time setup (on the friend's Mac)

```bash
curl -fsSL https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/main/install.sh | bash
```

This compiles all 15 wrappers into `.app` bundles in `~/StreamDockButtons/`.

Then in the Stream Deck app, for each of the 15 buttons:

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

## Testing a branch before merging to `main`

The button wrappers fetch from `main` by default. To test scripts on a branch (e.g. `harden`) without affecting the friend's Mac:

1. On your own Mac, manually fetch a single script from the branch to verify its behavior:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/harden/scripts/Row1-Col2.applescript -o /tmp/test.applescript
   osascript /tmp/test.applescript
   ```
2. Or temporarily point the cache at the branch version:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/soothslayer/stream-dock-applescript-buttons/harden/scripts/Row1-Col2.applescript \
     -o ~/Library/Application\ Support/StreamDockButtons/Row1-Col2.applescript
   ```
   Then press the button — it will try to fetch from `main`, but on network failure would fall back to your cached branch copy. (Cleaner: just test with `osascript` directly as in step 1.)
3. Once happy, merge the branch into `main`. Next press auto-updates.

## Troubleshooting

- **Button does nothing**: Gatekeeper may be blocking the unsigned `.app`. Right-click the `.app` in `~/StreamDockButtons/` → Open, accept the prompt, then try the button again.
- **Describe screen returns nothing**: check the API key is in Keychain (`security find-generic-password -a "$USER" -s ANTHROPIC_API_KEY -w`) and that `jq` is installed.
- **Keystrokes don't register**: Accessibility permission is missing for whatever is running the script.
- **`say` is silent**: system output volume is muted, or VoiceOver is capturing audio. Try unplugging any USB audio devices.
- **Cache won't refresh**: delete `~/Library/Application Support/StreamDockButtons/` and press the button again.
- **Scripts feel stale after an edit**: GitHub's raw CDN caches for ~5 minutes. Force-refresh by appending `?t=$(date +%s)` to the URL in the button wrapper (advanced — requires rebuilding the `.app`).
