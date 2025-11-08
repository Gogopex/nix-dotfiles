{ lib, config, ... }:
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

        configFile.text = builtins.readFile ./nushell-config.nu;

        envFile.text = /* nushell */ ''
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

          if (($"($env.HOME)/.volta" | path exists)) {
            $env.PATH = ($env.PATH | prepend $"($env.HOME)/.volta/bin")
            $env.VOLTA_HOME = $"($env.HOME)/.volta"
          }

          # API keys from agenix
          for key in [anthropic openai gemini deepseek openrouter groq] {
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
