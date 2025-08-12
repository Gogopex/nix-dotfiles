{ lib, pkgs, config, ... }:
let
  inherit (lib) enabled merge mkIf;
  zellijAutoStart = false;
  cfg = config.userShell;
  isFish = cfg == "fish";
in
mkIf isFish (merge {
  home-manager.sharedModules = [
    {
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
          # @FIX: broken
          notify = "run_with_notify";
          # @FIX: broken
          claude-check = "check_claude_sessions";
        };

        shellInit = # fish
          ''
            if status is-interactive
              fish_add_path -g /opt/homebrew/bin
              fish_add_path -g ~/.nix-profile/bin
              fish_add_path -g /etc/profiles/per-user/ludwig/bin
              fish_add_path -g /run/current-system/sw/bin
              fish_add_path -g /nix/var/nix/profiles/default/bin
              fish_add_path ~/.npm-global/bin
              fish_add_path ~/.local/bin ~/.modular/bin \
                             /Applications/WezTerm.app/Contents/MacOS \
                             $HOME/.cache/lm-studio/bin
              fish_add_path ~/Downloads/google-cloud-sdk/bin
            end



            for key in anthropic openai gemini deepseek openrouter groq
              if test -f /run/agenix/$key-api-key
                set -gx (string upper $key)_API_KEY (command cat /run/agenix/$key-api-key)
              end
            end

            if test -f /run/agenix/gemini-api-gcp-project-id
              set -gx GOOGLE_CLOUD_PROJECT (command cat /run/agenix/gemini-api-gcp-project-id)
            end
          '';

        interactiveShellInit = # fish
          ''
            set -gx EDITOR hx
            set -gx PHP_VERSION 8.3
            
            if test -d ~/.volta
              fish_add_path ~/.volta/bin
              set -gx VOLTA_HOME ~/.volta
            end

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
            if test -f ~/.orbstack/shell/init2.fish
              source ~/.orbstack/shell/init2.fish 2>/dev/null
            end
            
            if test -f ~/Downloads/google-cloud-sdk/path.fish.inc
              source ~/Downloads/google-cloud-sdk/path.fish.inc
            end

            # fish_mode_prompt is provided in functions below

            ${
              if zellijAutoStart then
                ''
                  if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"; and test -z "$NO_ZELLIJ"; and test -z "$GHOSTTY_QUICK_TERMINAL"
                    if command -v zellij >/dev/null 2>&1
                      # Attach to an existing session or create a new one
                      zellij attach -c
                    end
                  end
                ''
              else
                ""
            }

            # Fisher bootstrap disabled (plugins managed via nix)

            function fish_user_key_bindings
              bind \e\cv 'toggle_vim_mode'
              bind \e\cl 'open_links'
              bind \ca\cb 'br; commandline -f repaint'
              
              bind \c\; 'toggle_vim_mode'
            end

          '';

        functions = {
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
              bind -M default 0 'commandline -f beginning-of-line'
              bind -M default '$' 'commandline -f end-of-line'
              
              bind -M default gg 'commandline -f beginning-of-buffer'
              bind -M default G 'commandline -f end-of-buffer'
              
              bind -M visual gh 'commandline -f beginning-of-line'
              bind -M visual gl 'commandline -f end-of-line'
              bind -M visual 0 'commandline -f beginning-of-line'
              bind -M visual '$' 'commandline -f end-of-line'
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
              if not set -q ZELLIJ
                echo "Error: Not in a Zellij session"
                return 1
              end
              
              set -l temp_file (mktemp)
              
              if not zellij action dump-screen $temp_file
                echo "Error: Failed to dump Zellij screen"
                rm -f $temp_file
                return 1
              end
              
              set -l all_urls
              
              set -l standard_urls (command cat $temp_file | \
                rg -o -i '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' | \
                string collect)
              
              set -l markdown_urls (command cat $temp_file | \
                rg -o '\[([^\]]+)\]\(([^)]+)\)' -r '$2' | \
                string match -r '^https?://.*')
              
              set -l bare_domains (command cat $temp_file | \
                rg -o '\b([a-zA-Z0-9][-a-zA-Z0-9]*\.)+[a-zA-Z]{2,}\b(/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])?' | \
                string match -r -v '^(com|org|net|edu|gov|mil|int|example|test|localhost|invalid)$' | \
                string replace -r '^' 'https://')
              
              for url in $standard_urls $markdown_urls
                set all_urls $all_urls $url
              end
              
              set -l clean_urls
              for url in $all_urls
                # Remove trailing punctuation but keep it if it's part of the URL structure
                set -l cleaned (echo $url | string replace -r '([),;:!?\\."\']+)$' ''' | string trim)
                
                # Validate URL has a valid structure
                if string match -q -r '^(https?|ftp|file)://[^/]+' $cleaned
                  set clean_urls $clean_urls $cleaned
                end
              end
              
              set -l urls (printf '%s\n' $clean_urls | sort -u)
              
              # Clean up temp file
              rm -f $temp_file
              
              if test (count $urls) -eq 0
                echo "No URLs found in current Zellij pane"
                return 1
              end
              
              echo "Found "(count $urls)" URL(s)"
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

          br = ''
            function br --wraps=broot
              set -l cmd_file (mktemp)
              if broot --outcmd $cmd_file $argv
                set -l cmd (command cat $cmd_file)
                rm -f $cmd_file
                eval $cmd
              else
                set -l exit_code $status
                rm -f $cmd_file
                return $exit_code
              end
            end
          '';

        };

        plugins = [
          {
            name = "grc";
            src = pkgs.fishPlugins.grc.src;
          }
          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro.src;
          }
          {
            name = "gruvbox";
            src = pkgs.fishPlugins.gruvbox.src;
          }
          {
            name = "fzf-fish";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
        ];
      };
    }
  ];
})
