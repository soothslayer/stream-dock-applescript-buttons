#!/bin/bash
# One-time installer: compiles the 16 button wrappers into .app bundles
# in ~/StreamDockButtons/ so they can be assigned to Stream Deck buttons.
#
# After install, each .app is a fixed pointer. The real behavior of each
# button lives in scripts/ in the GitHub repo and can be updated remotely.

set -e

REPO="https://github.com/soothslayer/stream-dock-applescript-buttons.git"
DEST="$HOME/StreamDockButtons"

mkdir -p "$DEST"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Cloning $REPO ..."
git clone --depth 1 "$REPO" "$TMP"

echo "Compiling 15 button apps into $DEST ..."
for f in "$TMP"/buttons/*.applescript; do
  name=$(basename "$f" .applescript)
  osacompile -o "$DEST/$name.app" "$f"
  echo "  built $name.app"
done

say "Stream Deck buttons installed. 15 apps in Stream Dock Buttons folder." || true

echo ""
echo "Done. 15 apps are in: $DEST"
echo "Assign each one to its matching Stream Deck button:"
echo "  Row1-Col1.app = top-left button"
echo "  Row3-Col5.app = bottom-right button"
echo ""
echo "In Stream Deck app: drag 'System > Open' onto a button, set File to the .app."
