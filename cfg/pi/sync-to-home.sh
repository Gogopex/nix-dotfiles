#!/usr/bin/env bash
set -euo pipefail

SRC="/Users/ludwig/dev/dotfiles/cfg/pi"
DST="/Users/ludwig/.pi/agent"

mkdir -p "$DST/agents"

cp "$SRC/settings.json" "$DST/settings.json"
cp "$SRC/presets.json" "$DST/presets.json"
cp "$SRC/keybindings.json" "$DST/keybindings.json"
cp "$SRC/agents/"*.md "$DST/agents/"

echo "Synced settings, presets, keybindings, and agents to $DST"
