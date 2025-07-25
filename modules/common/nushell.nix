{ lib, pkgs, config, ... }:
let
  inherit (lib) enabled merge mkIf;
  cfg = config.userShell;
  isNushell = cfg == "nushell";
in
mkIf isNushell (merge {
  home-manager.sharedModules = [
    {
      programs.nushell = enabled {
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
          notify = "run_with_notify";
          claude-check = "check_claude_sessions";
        };

        configFile.text = '' 
          # Nushell Config File
          
          # Startup banner with welcome message
          $env.config = {
            show_banner: false
            edit_mode: vi
            
            keybindings: [
              {
                name: toggle_vim_mode
                modifier: control
                keycode: char_semicolon
                mode: [emacs, vi_normal, vi_insert]
                event: {
                  send: executehostcommand
                  cmd: "toggle_vim_mode"
                }
              }
              {
                name: open_links
                modifier: control_alt
                keycode: char_l
                mode: [emacs, vi_normal, vi_insert]
                event: {
                  send: executehostcommand
                  cmd: "open_links"
                }
              }
            ]
          }
          
          # Custom functions
          def toggle_vim_mode [] {
            if ($env.config.edit_mode == "vi") {
              print "Switching to emacs key bindings"
              $env.config.edit_mode = "emacs"
            } else {
              print "Switching to vi key bindings"
              $env.config.edit_mode = "vi"
            }
          }
          
          def open_links [] {
            if not ($env.ZELLIJ? | is-empty) {
              let temp_file = (mktemp)
              
              try {
                ^zellij action dump-screen $temp_file
                
                let urls = (
                  open $temp_file
                  | str find-all -r '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'
                  | get text
                  | uniq
                )
                
                rm $temp_file
                
                if ($urls | is-empty) {
                  print "No URLs found in current Zellij pane"
                } else {
                  print $"Found ($urls | length) URL\(s\)"
                  let selected = ($urls | to text | fzf --prompt="Select URL to open: " --height=40%)
                  
                  if not ($selected | is-empty) {
                    print $"Opening: ($selected)"
                    ^open $selected
                  }
                }
              } catch {
                print "Error: Failed to process Zellij screen"
                rm -f $temp_file
              }
            } else {
              print "Error: Not in a Zellij session"
            }
          }
          
          def fish_greeting [] {
            print "What is impossible for you is not impossible for me."
          }
          
          # Call greeting on startup
          fish_greeting
        '';

        envFile.text = ''
          # Nushell Environment Config File
          
          # Set up PATH
          $env.PATH = (
            $env.PATH
            | split row (char esep)
            | prepend /opt/homebrew/bin
            | prepend ~/.nix-profile/bin
            | prepend /etc/profiles/per-user/bin
            | prepend /run/current-system/sw/bin
            | prepend /nix/var/nix/profiles/default/bin
            | append ~/.npm-global/bin
            | append ~/.cargo/bin
            | append ~/.local/bin
            | append ~/.modular/bin
            | append /Applications/WezTerm.app/Contents/MacOS
            | append $"($env.HOME)/.cache/lm-studio/bin"
            | uniq
          )
          
          # Environment variables
          $env.EDITOR = "hx"
          $env.PHP_VERSION = "8.3"
          $env.GHCUP_INSTALL_BASE_PREFIX = $env.HOME
          
          # NVM setup
          if not (($"($env.HOME)/.nvm" | path exists)) {
            print "Installing nvm..."
            ^curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
          }
          if (($"($env.HOME)/.nvm" | path exists)) {
            $env.NVM_DIR = $"($env.HOME)/.nvm"
          }
          
          # Volta setup
          if (($"($env.HOME)/.volta" | path exists)) {
            $env.PATH = ($env.PATH | prepend $"($env.HOME)/.volta/bin")
            $env.VOLTA_HOME = $"($env.HOME)/.volta"
          }
          
          # API keys from agenix
          for key in [anthropic openai gemini deepseek openrouter] {
            let key_file = $"/run/agenix/($key)-api-key"
            if ($key_file | path exists) {
              let var_name = ($key | str upcase) + "_API_KEY"
              load-env {$var_name: (open $key_file | str trim)}
            }
          }
          
          if ("/run/agenix/gemini-api-gcp-project-id" | path exists) {
            $env.GOOGLE_CLOUD_PROJECT = (open /run/agenix/gemini-api-gcp-project-id | str trim)
          }
          
          # Ghostty integration
          if ($env.GHOSTTY_RESOURCES_DIR? | is-not-empty) {
            # Note: Nushell doesn't support sourcing fish scripts directly
            # You would need to port any ghostty shell integration manually
          }
          
          # Prompt configuration
          def create_left_prompt [] {
            let dir = (
              if (($env.PWD | str starts-with $env.HOME)) {
                ($env.PWD | str replace $env.HOME "~")
              } else {
                $env.PWD
              }
            )
            
            let nix_indicator = if ($env.IN_NIX_SHELL? | is-not-empty) { "❄ " } else { "" }
            
            $"($nix_indicator)(ansi green_bold)($dir)(ansi reset) "
          }
          
          def create_right_prompt [] {
            # Empty for now, can be customized later
            ""
          }
          
          $env.PROMPT_COMMAND = {|| create_left_prompt }
          $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
          $env.PROMPT_INDICATOR = {|| "> " }
          $env.PROMPT_INDICATOR_VI_INSERT = {|| "◇ " }
          $env.PROMPT_INDICATOR_VI_NORMAL = {|| "◆ " }
          $env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
        '';
      };

      programs.zoxide = enabled {
        enableNushellIntegration = true;
      };
    }
  ];
})
