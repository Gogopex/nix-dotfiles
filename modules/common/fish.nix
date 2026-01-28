{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) enabled merge mkIf;
  zellijAutoStart = true;
  zellijBaseSession = "main";
  cfg = config.userShell;
  isFish = cfg == "fish";
in
mkIf isFish (merge {
  home-manager.sharedModules = [
    {
      programs.fish = enabled {
        shellAliases = {
          ll = "ls -alh";
          lt  = "eza -la --group-directories-first --time-style=long-iso
          --binary --header --icons=never --no-user --no-permissions";
          ltg = "eza -la --group-directories-first --sort=modified --time-
          style=long-iso --git --binary --header --icons=never --no-user --no-
          permissions";

          lt1  = "eza -T -L 1 -a --group-directories-first --icons=never";
          lt1g = "eza -T -L 1 -a --group-directories-first --git --icons=never";
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
          cdx = "codex --search --model=gpt-5.2-codex -c model_reasoning_effort=\"high\" --sandbox workspace-write -c sandbox_workspace_write.network_access=true";
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
              fish_add_path ~/.cargo/bin
              fish_add_path ~/.local/bin ~/.modular/bin \
                             /Applications/WezTerm.app/Contents/MacOS \
                             $HOME/.cache/lm-studio/bin
              fish_add_path ~/Downloads/google-cloud-sdk/bin
            end

            for key in anthropic openai gemini deepseek openrouter groq glm
              if test -f /run/agenix/$key-api-key
                set -gx (string upper $key)_API_KEY (command cat /run/agenix/$key-api-key)
              end
            end

            if test -f /run/agenix/gemini-api-gcp-project-id
              set -gx GOOGLE_CLOUD_PROJECT (command cat /run/agenix/gemini-api-gcp-project-id)
            end

            if test -f /run/agenix/github-token
              set -l gh_token (command cat /run/agenix/github-token | string trim)
              set -gx GITHUB_TOKEN $gh_token
              if not set -q NIX_CONFIG
                set -gx NIX_CONFIG "access-tokens = github.com=$gh_token"
              else if not string match -q "*access-tokens = github.com=*" "$NIX_CONFIG"
                set -gx NIX_CONFIG "$NIX_CONFIG
access-tokens = github.com=$gh_token"
              end
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

            function __zj_aviator_update --on-event fish_prompt
              if not set -q ZELLIJ_PANE_ID
                return
              end
              if not command -v zellij >/dev/null 2>&1
                return
              end
              set -l pane $ZELLIJ_PANE_ID
              set -l pid $fish_pid
              set -l cwd_enc (string escape --style=url -- $PWD)
              set -l pgid (command ps -o pgid= -p $fish_pid | string trim)
              if test -n "$pgid"
                zellij pipe --name zj-aviator -- set pane=$pane pid=$pid pgid=$pgid cwd=$cwd_enc >/dev/null 2>&1
              else
                zellij pipe --name zj-aviator -- set pane=$pane pid=$pid cwd=$cwd_enc >/dev/null 2>&1
              end
            end

            ${
              if zellijAutoStart then
                ''
                  if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"; and test -z "$NO_ZELLIJ"; and test -z "$GHOSTTY_QUICK_TERMINAL"
                    if command -v zellij >/dev/null 2>&1
                      set -l base_session "${zellijBaseSession}"
                      if test -n "$base_session"
                        zellij attach --create "$base_session"
                      else
                        zellij attach -c
                      end
                    end
                  end
                ''
              else
                ""
            }

            function fish_user_key_bindings
              if functions -q fzf_configure_bindings
                fzf_configure_bindings
              end
              bind \e\cv 'toggle_vim_mode'
              bind \e\cl 'open_links'
              bind \ca\cb 'br; commandline -f repaint'
              
              bind \c\; 'toggle_vim_mode'
            end

            fish_user_key_bindings

          '';

        functions = {
          fish_greeting = ''echo "What is impossible for you is not impossible for me."'';

          cc = ''$argv | pbcopy'';
          ltf = ''
            function ltf --description "List files by modified time via eza + fzf with preview"
              eza --all --group-directories-first --sort=modified --oneline --color=never --icons=never | \
                fzf --preview 'if [ -d "{}" ]; then eza --long --all --group-directories-first --sort=modified --time-style=long-iso --git --binary --header --color=always --icons=never "{}" | head -n 200; else bat --style=numbers --color=always --paging=never --line-range :200 "{}" 2>/dev/null || eza --long --all --group-directories-first --sort=modified --time-style=long-iso --git --binary --header --color=always --icons=never "{}"; fi'
            end
          '';

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

          glm = ''
                        function glm --description 'Launch Claude Code via the GLM Coding Plan'
                          if not type -q claude
                            echo "Error: claude CLI is not installed (npm install -g @anthropic-ai/claude-code)."
                            return 127
                          end

                          if not set -q GLM_API_KEY
                            echo "Error: GLM_API_KEY is not set (expected from /run/agenix/glm-api-key)."
                            return 1
                          end

                          set -l settings_file (mktemp /tmp/glm-claude-settings.XXXXXX)
                          if test $status -ne 0
                            echo "Error: failed to create a temporary settings file."
                            return 1
                          end

                          env GLM_ALIAS_KEY=$GLM_API_KEY CLAUDE_SETTINGS_FILE=$settings_file python3 -c "
            import json
            import os
            import pathlib

            settings_path = pathlib.Path(os.environ['CLAUDE_SETTINGS_FILE'])
            payload = {
                'env': {
                    'ANTHROPIC_AUTH_TOKEN': os.environ['GLM_ALIAS_KEY'],
                    'ANTHROPIC_BASE_URL': 'https://api.z.ai/api/anthropic',
                    'API_TIMEOUT_MS': '3000000',
                    'ANTHROPIC_DEFAULT_HAIKU_MODEL': 'glm-4.5-air',
                    'ANTHROPIC_DEFAULT_SONNET_MODEL': 'glm-4.6',
                    'ANTHROPIC_DEFAULT_OPUS_MODEL': 'glm-4.6',
                }
            }
            settings_path.write_text(json.dumps(payload, indent=2))
            "

                          env \
                            ANTHROPIC_AUTH_TOKEN=$GLM_API_KEY \
                            ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic \
                            API_TIMEOUT_MS=3000000 \
                            ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.5-air \
                            ANTHROPIC_DEFAULT_SONNET_MODEL=glm-4.6 \
                            ANTHROPIC_DEFAULT_OPUS_MODEL=glm-4.6 \
                            claude --settings $settings_file $argv
                          set -l status $status
                          command rm -f $settings_file
                          return $status
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
              # Usage: links [LINES]
              set -l limit 400
              if test (count $argv) -gt 0
                if string match -rq '^[0-9]+$' -- $argv[1]
                  set limit $argv[1]
                end
              end
              set -l temp_file (mktemp)
              set -l source_desc ""
              
              if set -q ZELLIJ
                if not zellij action dump-screen $temp_file
                  echo "Error: Failed to dump Zellij screen"
                  rm -f $temp_file
                  return 1
                end
                command tail -n $limit $temp_file > $temp_file.tmp; and mv $temp_file.tmp $temp_file
                set source_desc "Zellij pane"
              else if set -q TMUX
                if not tmux capture-pane -p -S -$limit > $temp_file
                  echo "Error: Failed to capture tmux pane"
                  rm -f $temp_file
                  return 1
                end
                set source_desc "tmux pane"
              else
                history | head -n $limit > $temp_file
                set source_desc "command history (fallback)"
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
              
              for url in $standard_urls $markdown_urls $bare_domains
                set all_urls $all_urls $url
              end
              
              set -l clean_urls
              for url in $all_urls
                # Remove trailing punctuation but keep it if it's part of the URL structure
                set -l cleaned (echo $url | string replace -r "([),;:!?\\.\"']+)$" "" | string trim)
                
                # Validate URL has a valid structure
                if string match -q -r '^(https?|ftp|file)://[^/]+' $cleaned
                  set clean_urls $clean_urls $cleaned
                end
              end
              
              set -l urls (printf '%s\n' $clean_urls | sort -u)
              
              # Clean up temp file
              rm -f $temp_file
              
              if test (count $urls) -eq 0
                echo "No URLs found in $source_desc"
                return 1
              end
              
              echo "Found "(count $urls)" URL(s) from $source_desc"
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
