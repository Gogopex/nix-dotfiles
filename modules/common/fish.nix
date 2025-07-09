{ lib, pkgs, ... }: let
  inherit (lib) enabled merge;
  zellijAutoStart = false;
  mainSessionName = "main";
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
        zclean = "zclean";
        # @FIX: broken 
        notify = "run_with_notify";
        # @FIX: broken 
        claude-check = "check_claude_sessions";
        zm = "zmain";
        zw = "zwork";
      };
      
      shellInit = /* fish */ ''
        if status is-interactive
          fish_add_path -g /opt/homebrew/bin
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
        
        if test -f /run/agenix/gemini-api-gcp-project-id
          set -gx GOOGLE_CLOUD_PROJECT (cat /run/agenix/gemini-api-gcp-project-id)
        end
      '';
      
      interactiveShellInit = /* fish */ ''
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
        
        set -g hydro_multiline false
        set -g hydro_prompt_show_user false
        set -g hydro_prompt_show_host false
        
        if set -q GHOSTTY_RESOURCES_DIR
          source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
        end
        zoxide init fish | source
        source ~/.orbstack/shell/init2.fish 2>/dev/null || true
        
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
        
        ${if zellijAutoStart then ''
        if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"; and test -z "$NO_ZELLIJ"; and test -z "$GHOSTTY_QUICK_TERMINAL"
          if command -v zellij >/dev/null 2>&1
            # Attach to an existing session or create a new one
            zellij attach -c
          end
        end
        '' else ""}
        
        if not functions -q fisher
          curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        end
        
        function fish_user_key_bindings
          bind \e\cv 'toggle_vim_mode'
          bind \e\cl 'open_links'
          
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
            # Check if we're in a Zellij session
            if not set -q ZELLIJ
              echo "Error: Not in a Zellij session"
              return 1
            end
            
            # Create temp file for processing
            set -l temp_file (mktemp)
            
            # Dump the full scrollback
            zellij action dump-screen $temp_file 2>/dev/null
            
            # Process the dump to handle wrapped URLs
            # First, join lines that might be wrapped URLs
            set -l content (cat $temp_file | tr '\n' ' ')
            
            # Extract URLs with comprehensive pattern
            set -l urls (echo $content | \
              rg -o 'https?://[a-zA-Z0-9][a-zA-Z0-9\-._~:/?#\[\]@!$&()*+,;=%]+' | \
              string replace -r '[\s\|│┃].*$' "" | \
              string replace -r '[.,;:!?\])\"]+$' "" | \
              string match -r 'https?://[^/]+\.[^/]+.*' | \
              sort -u)
            
            # Clean up temp file
            rm -f $temp_file
            
            if test (count $urls) -eq 0
              echo "No URLs found in current Zellij pane"
              return 1
            end
            
            # Use fzf for selection
            set -l selected (printf '%s\n' $urls | \
              fzf --prompt="Select URL to open: " \
                  --preview-window=hidden \
                  --height=40%)
            
            if test -n "$selected"
              echo "Opening: $selected"
              open "$selected"
            end
          end
        '';
        
        notify_completion = ''
          function notify_completion
            set -l last_command (history | head -n 1)
            set -l exit_status $status
            
            printf "\a"
            
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
        
        zmain = ''
          function zmain
            echo "Switching to main session (${mainSessionName})..."
            zellij attach ${mainSessionName} -c
          end
        '';
        
        zwork = ''
          function zwork
            echo "Switching to work session..."
            zellij attach work -c
          end
        '';
        
        zclean = ''
          function zclean
            # Clean up EXITED Zellij sessions
            set -l exited_sessions (zellij list-sessions | grep "EXITED" | awk '{print $1}' | sed 's/\x1b\[[0-9;]*m//g')
            set -l count (count $exited_sessions)
            
            if test $count -eq 0
              echo "No exited sessions to clean up."
              return 0
            end
            
            echo "Found $count exited sessions to clean up:"
            for session in $exited_sessions
              echo "  - $session"
            end
            
            read -P "Delete all exited sessions? [y/N] " -n 1 confirm
            echo
            
            if test "$confirm" = "y" -o "$confirm" = "Y"
              for session in $exited_sessions
                echo "Deleting session: $session"
                zellij delete-session $session
              end
              echo "Cleaned up $count exited sessions."
            else
              echo "Cleanup cancelled."
            end
          end
        '';
        
      };
      
      plugins = [
        { name = "grc";     src = pkgs.fishPlugins.grc.src; }
        { name = "hydro";   src = pkgs.fishPlugins.hydro.src; }
        { name = "gruvbox"; src = pkgs.fishPlugins.gruvbox.src; }
      ];
    };
  }];
}
