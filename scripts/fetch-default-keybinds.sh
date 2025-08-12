set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_KBS_DIR="$SCRIPT_DIR/../default_kbs"

echo "Fetching default keybinding documentation..."

echo "1. Fetching Zellij default config..."
curl -fsSL "https://raw.githubusercontent.com/zellij-org/zellij/main/zellij-utils/assets/config/default.kdl" \
    -o "$DEFAULT_KBS_DIR/zellij-default.kdl" || {
    echo "Failed to fetch Zellij config"
    exit 1
}

echo "2. Fetching Helix keymap documentation..."
curl -fsSL "https://raw.githubusercontent.com/helix-editor/helix/master/book/src/keymap.md" \
    -o "$DEFAULT_KBS_DIR/helix-keymap.md" || {
    echo "Failed to fetch Helix keymap"
    exit 1
}

echo "3. Fetching AeroSpace commands documentation..."
curl -fsSL "https://raw.githubusercontent.com/nikitabobko/AeroSpace/main/docs/commands.adoc" \
    -o "$DEFAULT_KBS_DIR/aerospace-commands.adoc" || {
    echo "Failed to fetch AeroSpace commands"
    exit 1
}

echo "All files downloaded successfully to $DEFAULT_KBS_DIR/"
ls -la "$DEFAULT_KBS_DIR/"
