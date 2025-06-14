declare -A plugins=(
    ["readwise-official"]="https://github.com/readwiseio/obsidian-readwise/archive/refs/tags/3.0.1.tar.gz"
    ["smart-composer"]="https://github.com/glowingjade/obsidian-smart-composer/archive/refs/tags/v0.2.5.tar.gz"
    ["obsidian-zotero-desktop-connector"]="https://github.com/mgmeyers/obsidian-zotero-integration/archive/refs/tags/3.2.9.tar.gz"
    ["better-word-count"]="https://github.com/lukeleppan/better-word-count/archive/refs/tags/0.9.5.tar.gz"
    ["mermaid-tools"]="https://github.com/dartungar/obsidian-mermaid/archive/refs/tags/1.20.0.tar.gz"
)

echo "computing sha256 hashes for obsidian plugins..."
echo ""

for plugin in "${!plugins[@]}"; do
    url="${plugins[$plugin]}"
    echo "fetching $plugin from $url"
    
    hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "  hash: $hash"
        echo ""
    else
        echo "  error: failed to fetch $plugin"
        echo ""
    fi
done

echo "copy these hashes into your flake.nix obsidian plugin configuration" 
