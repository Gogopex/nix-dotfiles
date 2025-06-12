if status is-interactive
    # Aliases
    alias ll 'ls -alh'
    alias dr 'sudo -E env PATH=$PATH HOME=/var/root nix run github:LnL7/nix-darwin#darwin-rebuild -- switch --flake ~/dev/dotfiles#macbook'
    alias ingest '~/go/bin/ingest'
    
    # Environment variables
    set -gx EDITOR hx
    set -gx PHP_VERSION 8.3
    set -gx GHCUP_INSTALL_BASE_PREFIX $HOME
    
    # PATH additions
    fish_add_path ~/.npm-global/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.modular/bin
    fish_add_path /Applications/WezTerm.app/Contents/MacOS
    fish_add_path $HOME/.cache/lm-studio/bin
    
    # External integrations
    if test -f ~/.orbstack/shell/init2.fish
        source ~/.orbstack/shell/init2.fish
    end
    
    # Zellij auto-start for Ghostty
    if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"
        exec zellij
    end
    
    # Fisher and plugins
    if not functions -q fisher
        # Install fisher if not present
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end
end