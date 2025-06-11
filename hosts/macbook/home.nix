{ config, pkgs, ghosttySrc, ... }:

let
  leader = "C-Space";
  cfg    = ../../cfg;
in {
  home.stateVersion              = "25.05";

  xdg.configFile."nvim".source              = cfg + "/nvim";
  xdg.configFile."helix".source             = cfg + "/helix";
  xdg.configFile."zellij/config.kdl".source = cfg + "/zellij/config.kdl";
  # xdg.configFile."ghostty".source         = cfg + "/ghostty";
  # home.file."Library/Application Support/Raycast".source =
  #   cfg + "/raycast/app-support";

  # ── Ghostty -------------------------------------------------------------
  programs.ghostty = {
    enable               = true;
    package              = null;        
    clearDefaultKeybinds = true;

    settings = {
      theme                    = "GruvboxDark";
      font-family              = "TX-02-Regular";
      window-title-font-family = "TX-02";
      font-size                = 16;
      shell-integration        = "fish";
      confirm-close-surface    = false;
      macos-titlebar-style     = "tabs";
      window-save-state        = "always";
      auto-update              = "off";

      keybind = [
        "ctrl+space=toggle_fullscreen"

        "ctrl+h=goto_split:left"
        "ctrl+j=goto_split:down"
        "ctrl+k=goto_split:up"
        "ctrl+l=goto_split:right"

        "cmd+h=previous_tab"
        "cmd+l=next_tab"

        "super+ctrl+h=resize_split:left,10"
        "super+ctrl+j=resize_split:down,10"
        "super+ctrl+k=resize_split:up,10"
        "super+ctrl+l=resize_split:right,10"

        "global:shift+opt+t=toggle_quick_terminal"
      ];
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g prefix ${leader}
      bind ${leader} send-prefix
      set -g mouse on
      bind ${leader} split-window -v
    '';
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      keys.normal."${leader}" = ":w";
    };
  };

  programs.neovim = {
    enable  = true;
    viAlias = true;
    extraConfig = ''
      let mapleader="\<Space>"
      nnoremap <leader>w :w<CR>
    '';
    plugins = with pkgs.vimPlugins; [ telescope-nvim nvim-treesitter ];
  };

  programs.yazi = {
    enable = true;
    settings = {
      log.enabled = false;
      manager = {
        show_hidden = true;
        sort_by     = "mtime";
      };
      keymap.normal."${leader}" = "toggle_preview";
    };
  };

  programs.zoxide.enable = true;

  xdg.configFile."jj/config.toml".text = ''
    [ui]
    default-command = "log"
    
    [user]
    name = "ludwig"
    email = "gogopex@gmail.com"
  '';
  
  home.packages = with pkgs; [
    jujutsu
    bandwhich
    zoxide
    fzf
    ripgrep
    bat
    fd
    eza
    git
    curl
    wget
    direnv
    zellij
    delta  
    zig
    zls
    odin
    go
    rustc
    cargo
    rustfmt
    rust-analyzer
    ghc
    cabal-install
    stack
    haskell-language-server
    nixfmt-rfc-style
    nil
    volta
    maven
    openjdk
    wiki-tui
  ];

  programs.go.enable = true;

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -alh";
      dr = "sudo darwin-rebuild switch --flake .#macbook";
      ingest = "~/go/bin/ingest";
    };

    shellInit = ''
      # Add Nix paths first
      fish_add_path -g ~/.nix-profile/bin
      fish_add_path -g /etc/profiles/per-user/$USER/bin
      fish_add_path -g /run/current-system/sw/bin
      fish_add_path -g /nix/var/nix/profiles/default/bin

      fish_add_path ~/.npm-global/bin

      # Load API keys from agenix (decrypted at /run/agenix/)
      if test -f /run/agenix/anthropic-api-key
        set -gx ANTHROPIC_API_KEY (cat /run/agenix/anthropic-api-key)
      end
      
      if test -f /run/agenix/openai-api-key
        set -gx OPENAI_API_KEY (cat /run/agenix/openai-api-key)
      end
      
      if test -f /run/agenix/gemini-api-key
        set -gx GEMINI_API_KEY (cat /run/agenix/gemini-api-key)
      end
      
      if test -f /run/agenix/deepseek-api-key
        set -gx DEEPSEEK_API_KEY (cat /run/agenix/deepseek-api-key)
      end
      fish_add_path ~/.local/bin
      fish_add_path ~/.modular/bin
      fish_add_path /Applications/WezTerm.app/Contents/MacOS
      fish_add_path $HOME/.cache/lm-studio/bin
    '';

    interactiveShellInit = ''
      set -gx EDITOR hx
      set -gx PHP_VERSION 8.3
      set -gx GHCUP_INSTALL_BASE_PREFIX $HOME

      if set -q GHOSTTY_RESOURCES_DIR
        source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
      end

      if test -f "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
        source "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
      end

      zoxide init fish | source
      source ~/.orbstack/shell/init2.fish 2>/dev/null || true
    '';

    functions = {
      ssh_tt = ''
        function ssh_tt
          ssh user@38.97.6.9 -p 56501 -t "tmux new -s main || tmux attach -t main"
        end
      '';
      fish_greeting = ''
        echo "What is impossible for you is not impossible for me."
      '';
    };

    plugins = [
      { name = "grc";   src = pkgs.fishPlugins.grc; }
      { name = "z";     src = pkgs.fishPlugins.z; }
      { name = "hydro"; src = pkgs.fishPlugins.hydro; }
    ];
  };

  programs.git = {
    enable = true;
    userName  = "ludwig";
    userEmail = "gogopex@gmail.com";
  };

  programs.btop = {
    enable = true;
    settings.color_theme = "gruvbox_dark";
  };
}
