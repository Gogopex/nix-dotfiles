{ config, lib, pkgs, ... }: let
  inherit (lib) enabled merge;
in merge {
  home-manager.sharedModules = [{
    programs.fish = enabled {
      shellAliases = {
        ll = "ls -alh";
        dr = "sudo darwin-rebuild switch --flake .#macbook";
        ingest = "~/go/bin/ingest";
        cat = "bat";
        ps = "procs";
        du = "dust";
        top = "btop";
        help = "tldr";
        md = "glow";
        lg = "lazygit";
        bench = "hyperfine";
        vim-mode = "toggle_vim_mode";
        links = "open_links";
        zls = "zellij list-sessions";
        zdel = "zellij delete-session";
        zforce = "zellij attach --force-run-commands";
        zt = "zellij_tab_switcher";
        notify = "run_with_notify";
        claude-check = "check_claude_sessions";
        zm = "zmain";
        zw = "zwork";
      };
      
      shellInit = /* fish */ ''
        if status is-interactive
          fish_add_path -g ~/.nix-profile/bin
          fish_add_path -g /etc/profiles/per-user/bin
          fish_add_path -g /run/current-system/sw/bin
          fish_add_path -g /nix/var/nix/profiles/default/bin
          fish_add_path ~/.npm-global/bin
          fish_add_path ~/.cargo/bin
          fish_add_path ~/.local/bin ~/.modular/bin \
                         /Applications/WezTerm.app/Contents/MacOS \
                         $HOME/.cache/lm-studio/bin
        end

        if not test -d ~/.nvm
          echo "Installing nvm..."
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        end
        if test -d ~/.nvm
          set -gx NVM_DIR ~/.nvm
        end

        if test -d ~/.volta
          fish_add_path ~/.volta/bin
          set -gx VOLTA_HOME ~/.volta
        end

        for key in anthropic openai gemini deepseek
          if test -f /run/agenix/$key-api-key
            set -gx (string upper $key)_API_KEY (cat /run/agenix/$key-api-key)
          end
        end
      '';
      
      interactiveShellInit = ''
        set -gx EDITOR hx
        set -gx PHP_VERSION 8.3
        set -gx GHCUP_INSTALL_BASE_PREFIX $HOME
        
        fish_vi_key_bindings
        setup_enhanced_vi_mode
        
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_replace_one underscore
        set -g fish_cursor_replace underscore
        set -g fish_cursor_external line
        set -g fish_cursor_visual block
        
        theme_gruvbox dark
        if set -q GHOSTTY_RESOURCES_DIR
          source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
        end
        zoxide init fish | source
        source ~/.orbstack/shell/init2.fish 2>/dev/null || true
        
        # Override hydro's fish_mode_prompt with our custom one
        functions -e fish_mode_prompt 2>/dev/null
        function fish_mode_prompt --description 'Display the current vi mode'
          switch $fish_bind_mode
            case default
              set_color -o brgreen
              echo -n "◆ "
              set_color normal
            case insert
              set_color -o bryellow
              echo -n "◇ "
              set_color normal
            case replace_one
              set_color -o brred
              echo -n "◈ "
              set_color normal
            case replace
              set_color -o brred
              echo -n "▓ "
              set_color normal
            case visual
              set_color -o brmagenta
              echo -n "◉ "
              set_color normal
          end
        end
        
        if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"; and test -z "$NO_ZELLIJ"; and test -z "$GHOSTTY_QUICK_TERMINAL"
          if command -v zellij >/dev/null 2>&1
            zellij attach circular-crab
          end
        end
        
        if not functions -q fisher
          # Install fisher if not present
          curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        end
        
        function fish_user_key_bindings
          # Use Ctrl+Alt combinations to avoid conflicts
          bind \e\cv 'toggle_vim_mode'
          bind \e\cl 'open_links'
          
          # Ctrl+; toggles between vi mode and default mode
          bind \c\; 'toggle_vim_mode'
        end
      '';
      
      functions = {
        ssh_tt = ''
          function ssh_tt
            ssh user@38.97.6.9 -p 56501 -t "tmux new -s main || tmux attach -t main"
          end
        '';
        
        fish_greeting = ''echo "What is impossible for you is not impossible for me."'';
        
        cc = ''$argv | pbcopy'';
        
        fish_mode_prompt = ''
          function fish_mode_prompt
            switch $fish_bind_mode
              case default
                set_color -o brgreen
                echo -n "◆ "
                set_color normal
              case insert
                set_color -o bryellow
                echo -n "◇ "
                set_color normal
              case replace_one
                set_color -o brred
                echo -n "◈ "
                set_color normal
              case replace
                set_color -o brred
                echo -n "▓ "
                set_color normal
              case visual
                set_color -o brmagenta
                echo -n "◉ "
                set_color normal
            end
          end
        '';
        
        nix_shell_prompt = ''
          function nix_shell_prompt
            if test -n "$IN_NIX_SHELL"
              set_color -o brcyan
              echo -n "❄"
              set_color normal
            end
          end
        '';
        
        fish_right_prompt = ''
          function fish_right_prompt
            nix_shell_prompt
          end
        '';
        
        setup_enhanced_vi_mode = ''
          function setup_enhanced_vi_mode
            set -g fish_cursor_default block
            set -g fish_cursor_insert line
            set -g fish_cursor_replace_one underscore
            set -g fish_cursor_replace underscore
            set -g fish_cursor_external line
            set -g fish_cursor_visual block
            
            bind -M default V 'commandline -f beginning-of-line visual-mode end-of-line'
            
            bind -M default gh 'commandline -f beginning-of-line'
            bind -M default gl 'commandline -f end-of-line'
            
            bind -M default gg 'commandline -f beginning-of-buffer'
            bind -M default G 'commandline -f end-of-buffer'
            
            bind -M visual gh 'commandline -f beginning-of-line'
            bind -M visual gl 'commandline -f end-of-line'
            bind -M visual gg 'commandline -f beginning-of-buffer'
            bind -M visual G 'commandline -f end-of-buffer'
          end
        '';
        
        toggle_vim_mode = ''
          function toggle_vim_mode
            if test "$fish_key_bindings" = "fish_vi_key_bindings"
              echo "Switching to default key bindings"
              fish_default_key_bindings
              set -g fish_key_bindings fish_default_key_bindings
            else
              echo "Switching to enhanced vim key bindings"
              fish_vi_key_bindings
              setup_enhanced_vi_mode
              set -g fish_key_bindings fish_vi_key_bindings
            end
          end
        '';
        
        open_links = ''
          function open_links
            # Extract URLs from Zellij scrollback and open with fzf selection
            # Create a temporary file to capture Zellij scrollback
            set -l temp_file (mktemp)
            
            # Use Zellij to dump the current pane's scrollback
            zellij action dump-screen $temp_file
            
            # Extract URLs from the dumped content
            set -l urls (cat $temp_file | grep -oE 'https?://[^\s]+' | sort -u)
            
            # Clean up temp file
            rm -f $temp_file
            
            if test (count $urls) -eq 0
              echo "No URLs found in current Zellij pane output"
              return 1
            end
            
            set -l selected (printf '%s\n' $urls | fzf --prompt="Select URL to open: ")
            if test -n "$selected"
              echo "Opening: $selected"
              open "$selected"
            end
          end
        '';
        
        zres = ''
          function zres
            if test (count $argv) -eq 0
              echo "Usage: zres <session-name>"
              echo "Available sessions:"
              zellij list-sessions
              return 1
            end
            
            set -l session_name $argv[1]
            echo "Resurrecting session: $session_name"
            zellij attach $session_name
          end
        '';
        
        notify_completion = ''
          function notify_completion
            # Get the command that just finished
            set -l last_command (history | head -n 1)
            set -l exit_status $status
            
            # Send bell signal to trigger zjstatus notification
            printf "\a"
            
            # Optional: show completion status
            if test $exit_status -eq 0
              echo "[OK] Command completed: $last_command"
            else
              echo "[FAIL] Command failed ($exit_status): $last_command"
            end
          end
        '';
        
        run_with_notify = ''
          function run_with_notify
            if test (count $argv) -eq 0
              echo "Usage: run_with_notify <command> [args...]"
              return 1
            end
            
            echo ">> Starting: $argv"
            eval $argv
            set -l exit_status $status
            
            # Trigger notification
            printf "\a"
            
            if test $exit_status -eq 0
              echo ">> Completed: $argv"
            else
              echo ">> Failed ($exit_status): $argv"
            end
            
            return $exit_status
          end
        '';
        
        check_claude_sessions = ''
          function check_claude_sessions
            # Look for claude processes that might be waiting
            set -l claude_procs (ps aux | grep -i claude | grep -v grep)
            if test -n "$claude_procs"
              printf "\a"
              echo ">> Claude Code session detected"
            end
          end
        '';
        
        zellij_tab_switcher = ''
          function zellij_tab_switcher
            # Get all tab names from zellij
            set -l tabs (zellij action query-tab-names 2>/dev/null)
            
            if test -z "$tabs"
              echo "No tabs found"
              return 1
            end
            
            # Add line numbers for quick selection and pipe to fzf
            set -l selected (printf '%s\n' $tabs | nl -w2 -s': ' | \
              fzf --height=40% --layout=reverse --border \
                  --prompt="Select tab (or press number): " \
                  --preview-window=hidden \
                  --bind='1:accept,2:accept,3:accept,4:accept,5:accept,6:accept,7:accept,8:accept,9:accept')
            
            if test -n "$selected"
              # Extract the tab name (remove the line number prefix)
              set -l tab_name (echo $selected | sed 's/^[[:space:]]*[0-9]*:[[:space:]]*//')
              
              # Switch to the selected tab
              zellij action go-to-tab-name "$tab_name"
              
              # Close the floating pane (if we're in one)
              zellij action toggle-floating-panes 2>/dev/null
            end
          end
        '';
        
        zmain = ''
          function zmain
            echo "Switching to main session (circular-crab)..."
            zellij attach circular-crab
          end
        '';
        
        zwork = ''
          function zwork
            echo "Switching to work session..."
            # Create work session with layout if it doesn't exist, otherwise just attach
            zellij --layout work --session work
          end
        '';
      };
      
      plugins = [
        { name = "grc";     src = pkgs.fishPlugins.grc; }
        { name = "hydro";   src = pkgs.fishPlugins.hydro; }
        { name = "gruvbox"; src = pkgs.fishPlugins.gruvbox; }
      ];
    };
  }];
}