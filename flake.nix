{
  description = "macOS dev environment";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url   = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ghosttySrc.url   = "github:ghostty-org/ghostty";
    agenix.url       = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, agenix, ghosttySrc, ... }:
  let
    system = "aarch64-darwin";
    pkgs   = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
  in
  {
    packages.default = pkgs.hello;

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      inherit system pkgs;

      modules = [
        ./hosts/macbook/darwin.nix
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default

        ({ config, pkgs, ghosttySrc, ... }: let
            leader = "C-Space";
            cfg    = ./cfg;                
          in {
            # glue: make HM see the host-level pkgs & args
            users.users.ludwig.home = "/Users/ludwig";
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit ghosttySrc; };

            home-manager.users.ludwig = { pkgs, lib, ... }: let
              darwinOnly = lib.mkIf pkgs.stdenv.isDarwin;
            in {
              home.stateVersion = "25.05";

              xdg.configFile."nvim".source              = cfg + "/nvim";
              # aerospace config is now provided by home-manager module, no manual file needed

              programs.ghostty = {
                enable = true;
                package = null;
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
                    # ghostty tab management
                    "cmd+shift+t=new_tab"
                    # pass through to Zellij for pane navigation
                    "ctrl+h=unbind"   "ctrl+j=unbind"
                    "ctrl+k=unbind"   "ctrl+l=unbind"
                    # pass through to Zellij for tab navigation
                    "cmd+h=unbind"    "cmd+l=unbind"
                    "cmd+t=unbind"    "cmd+w=unbind"
                    # pass through to Zellij for pane splitting
                    "cmd+d=unbind"    "cmd+shift+d=unbind"
                    "cmd+shift+w=unbind"
                    # pass through to Zellij for pane resizing
                    "cmd+ctrl+h=unbind"
                    "cmd+ctrl+j=unbind"
                    "cmd+ctrl+k=unbind"
                    "cmd+ctrl+l=unbind"
                    # tab movement (Ghostty owns arrow combos, letters go to Zellij)
                    "cmd+ctrl+shift+left=move_tab:-1"
                    "cmd+ctrl+shift+right=move_tab:1"
                    # pass through to Zellij for tab re-ordering
                    "cmd+ctrl+shift+h=unbind"
                    "cmd+ctrl+shift+l=unbind"
                    "global:shift+opt+t=toggle_quick_terminal"
                  ];
                };
              };

              programs.zellij = {
                enable = true;
                settings = {
                  simplified_ui = true;
                  default_shell = "fish";
                  theme = "gruvbox-dark";
                  default_layout = "compact";
                  copy_command = "pbcopy";
                  copy_on_select = true;
                  keybinds = {
                    normal = {
                      # tab navigation (matching Ghostty keybinds)
                      "bind \"Super h\"" = { GoToPreviousTab = {}; };
                      "bind \"Super l\"" = { GoToNextTab = {}; };
                      "bind \"Super t\"" = { NewTab = {}; };
                      "bind \"Super w\"" = { CloseTab = {}; };
                      
                      # pane navigation (matching Ghostty keybinds)
                      "bind \"Ctrl h\"" = { MoveFocus = "Left"; };
                      "bind \"Ctrl j\"" = { MoveFocus = "Down"; };
                      "bind \"Ctrl k\"" = { MoveFocus = "Up"; };
                      "bind \"Ctrl l\"" = { MoveFocus = "Right"; };
                      
                      # pane resizing (matching Ghostty keybinds)
                      "bind \"Super Ctrl h\"" = { Resize = "Increase Left"; };
                      "bind \"Super Ctrl j\"" = { Resize = "Increase Down"; };
                      "bind \"Super Ctrl k\"" = { Resize = "Increase Up"; };
                      "bind \"Super Ctrl l\"" = { Resize = "Increase Right"; };
                      
                      # pane management
                      "bind \"Super d\"" = { NewPane = "Right"; };
                      "bind \"Super Shift d\"" = { NewPane = "Down"; };
                      "bind \"Super Shift w\"" = { CloseFocus = {}; };
                      
                      # pane movement
                      "bind \"Super Shift h\"" = { MovePane = "Left"; };
                      "bind \"Super Shift j\"" = { MovePane = "Down"; };
                      "bind \"Super Shift k\"" = { MovePane = "Up"; };
                      "bind \"Super Shift l\"" = { MovePane = "Right"; };
                      
                      # pane stacking and fullscreen
                      "bind \"Super f\"" = { ToggleFocusFullscreen = {}; };
                      "bind \"Super z\"" = { TogglePaneFrames = {}; };
                      
                      # tab movement
                      "bind \"Super Ctrl Shift h\"" = { MoveTab = "Left"; };
                      "bind \"Super Ctrl Shift l\"" = { MoveTab = "Right"; };
                      
                      # mode switching
                      "bind \"Ctrl a\"" = { SwitchToMode = "Tmux"; };
                      
                      # essential shortcuts
                      "bind \"Ctrl q\"" = { Quit = {}; };
                      "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
                      "bind \"Ctrl ;\"" = { SwitchToMode = "Scroll"; };
                    };
                    layouts = {
                       dev = {
                        panes = [
                          { run = "hx"; }
                          {
                            direction = "Right";
                            size = "35%";
                            panes = [
                              { }
                              { }
                            ];
                          }
                        ];
                      };
                       tt-evolve = {
                        panes = [
                          { run = "hx"; }
                          {
                            direction = "Right";
                            size = "35%";
                            panes = [
                              { run = "cd tui/ttop; cargo run"; }
                              { run = "cd tui/ttop; cargo watch"; }
                            ];
                          }
                        ];
                      };
                    };

                    locked = {
                      "bind \"Ctrl g\"" = { SwitchToMode = "Normal"; };
                    };
                  };
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
                languages = {
                  language = [
                    {
                      name = "nix";
                      formatter = {
                        command = "nixfmt-rfc-style";
                      };
                    }
                  ];
                };
                settings = {
                  theme = "gruvbox";
                  editor = {
                    line-number = "relative";
                    mouse = false;
                    cursor-shape = {
                      insert = "bar";
                      normal = "block";
                      select = "underline";
                    };
                    file-picker.hidden = false;
                    statusline = {
                      left = ["mode" "spinner"];
                      center = ["file-name"];
                      right = [
                        "diagnostics"
                        "selections"
                        "position"
                        "file-encoding"
                        "file-line-ending"
                        "file-type"
                      ];
                      separator = "│";
                      mode = {
                        normal = "NORMAL";
                        insert = "INSERT";
                        select = "SELECT";
                      };
                    };
                  };
                  keys = {
                    normal = {
                      # quick iteration on config changes
                      "C-o" = ":config-open";
                      "C-r" = ":config-reload";
                      
                      "C-h" = "select_prev_sibling";
                      "C-j" = "shrink_selection";
                      "C-k" = "expand_selection";
                      "C-l" = "select_next_sibling";
                      
                      o = ["open_below" "normal_mode"];
                      O = ["open_above" "normal_mode"];
                      
                      "{" = ["goto_prev_paragraph" "collapse_selection"];
                      "}" = ["goto_next_paragraph" "collapse_selection"];
                      "0" = "goto_line_start";
                      "$" = "goto_line_end";
                      "^" = "goto_first_nonwhitespace";
                      G = "goto_file_end";
                      "%" = "match_brackets";
                      V = ["select_mode" "extend_to_line_bounds"];
                      C = [
                        "extend_to_line_end"
                        "yank_main_selection_to_clipboard"
                        "delete_selection"
                        "insert_mode"
                      ];
                      D = [
                        "extend_to_line_end"
                        "yank_main_selection_to_clipboard"
                        "delete_selection"
                      ];
                      S = "surround_add";
                      
                      x = "delete_selection";
                      p = ["paste_clipboard_after" "collapse_selection"];
                      P = ["paste_clipboard_before" "collapse_selection"];
                      Y = [
                        "extend_to_line_end"
                        "yank_main_selection_to_clipboard"
                        "collapse_selection"
                      ];
                      
                      w = ["move_next_word_start" "move_char_right" "collapse_selection"];
                      W = ["move_next_long_word_start" "move_char_right" "collapse_selection"];
                      e = ["move_next_word_end" "collapse_selection"];
                      E = ["move_next_long_word_end" "collapse_selection"];
                      b = ["move_prev_word_start" "collapse_selection"];
                      B = ["move_prev_long_word_start" "collapse_selection"];
                      
                      i = ["insert_mode" "collapse_selection"];
                      a = ["append_mode" "collapse_selection"];
                      
                      u = ["undo" "collapse_selection"];
                      
                      esc = ["collapse_selection" "keep_primary_selection"];
                      
                      "*" = [
                        "move_char_right"
                        "move_prev_word_start"
                        "move_next_word_end"
                        "search_selection"
                        "search_next"
                      ];
                      "#" = [
                        "move_char_right"
                        "move_prev_word_start"
                        "move_next_word_end"
                        "search_selection"
                        "search_prev"
                      ];
                      
                      j = "move_line_down";
                      k = "move_line_up";
                      
                      d = {
                        d = [
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                        ];
                        t = ["extend_till_char"];
                        s = ["surround_delete"];
                        i = ["select_textobject_inner"];
                        a = ["select_textobject_around"];
                        j = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_below"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                        down = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_below"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                        k = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_above"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                        up = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_above"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                        G = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "goto_last_line"
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                        w = [
                          "move_next_word_start"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                        ];
                        W = [
                          "move_next_long_word_start"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                        ];
                        g.g = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "goto_file_start"
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "delete_selection"
                          "normal_mode"
                        ];
                      };
                      
                      y = {
                        y = [
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "normal_mode"
                          "collapse_selection"
                        ];
                        j = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_below"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        down = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_below"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        k = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_above"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        up = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "extend_line_above"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        G = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "goto_last_line"
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        w = [
                          "move_next_word_start"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        W = [
                          "move_next_long_word_start"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                        g.g = [
                          "select_mode"
                          "extend_to_line_bounds"
                          "goto_file_start"
                          "extend_to_line_bounds"
                          "yank_main_selection_to_clipboard"
                          "collapse_selection"
                          "normal_mode"
                        ];
                      };
                    };
                    insert = {
                      esc = ["collapse_selection" "normal_mode"];
                    };
                    select = {
                      "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
                      "}" = ["extend_to_line_bounds" "goto_next_paragraph"];
                      "0" = "goto_line_start";
                      "$" = "goto_line_end";
                      "^" = "goto_first_nonwhitespace";
                      G = "goto_file_end";
                      D = ["extend_to_line_bounds" "delete_selection" "normal_mode"];
                      C = ["goto_line_start" "extend_to_line_bounds" "change_selection"];
                      "%" = "match_brackets";
                      S = "surround_add";
                      u = ["switch_to_lowercase" "collapse_selection" "normal_mode"];
                      U = ["switch_to_uppercase" "collapse_selection" "normal_mode"];
                      
                      i = "select_textobject_inner";
                      a = "select_textobject_around";
                      
                      tab = ["insert_mode" "collapse_selection"];
                      "C-a" = ["append_mode" "collapse_selection"];
                      
                      k = ["extend_line_up" "extend_to_line_bounds"];
                      j = ["extend_line_down" "extend_to_line_bounds"];
                      
                      d = ["yank_main_selection_to_clipboard" "delete_selection"];
                      x = ["yank_main_selection_to_clipboard" "delete_selection"];
                      y = [
                        "yank_main_selection_to_clipboard"
                        "normal_mode"
                        "flip_selections"
                        "collapse_selection"
                      ];
                      Y = [
                        "extend_to_line_bounds"
                        "yank_main_selection_to_clipboard"
                        "goto_line_start"
                        "collapse_selection"
                        "normal_mode"
                      ];
                      p = "replace_selections_with_clipboard";
                      P = "paste_clipboard_before";
                      
                      esc = ["collapse_selection" "keep_primary_selection" "normal_mode"];
                    };
                  };
                };
              };

              programs.neovim = {
                enable  = true;
                viAlias = true;
                extraConfig = /* vim */ ''
                  let mapleader="\<Space>"
                  nnoremap <leader>w :w<CR>
                '';
                plugins = with pkgs.vimPlugins; [ telescope-nvim nvim-treesitter ];
              };

              programs.yazi = {
                enable = true;
                settings = {
                  log.enabled = false;
                  manager = { show_hidden = true; sort_by = "mtime"; };
                  keymap.normal."${leader}" = "toggle_preview";
                };
              };

              programs.zoxide.enable = true;

              programs.jujutsu = {
                enable = true;
                settings = {
                  ui.default-command = "log";
                  user.name  = "ludwig";
                  user.email = "gogopex@gmail.com";
                };
              };

              home.packages = with pkgs; (
                [ bandwhich zoxide fzf ripgrep bat fd eza git curl wget direnv
                  zellij delta zig zls odin go rustc cargo rustfmt rust-analyzer
                  ghc cabal-install stack haskell-language-server
                  nixfmt-rfc-style nil volta maven openjdk wiki-tui tokei
                  mutagen mutagen-compose agenix.packages.${system}.default
                  obsidian
                ] ++ lib.optionals pkgs.stdenv.isDarwin [ zotero ]
              );

              programs.go.enable = true;

              programs.fish = {
                enable = true;
                shellAliases = {
                  ll = "ls -alh";
                  dr = "sudo darwin-rebuild switch --flake .#macbook";
                  ingest = "~/go/bin/ingest";
                };
                shellInit = /* fish */ ''
                  if status is-interactive
                    fish_add_path -g ~/.nix-profile/bin
                    fish_add_path -g /etc/profiles/per-user/bin
                    fish_add_path -g /run/current-system/sw/bin
                    fish_add_path -g /nix/var/nix/profiles/default/bin
                    fish_add_path ~/.npm-global/bin
                    fish_add_path ~/.local/bin ~/.modular/bin \
                                   /Applications/WezTerm.app/Contents/MacOS \
                                   $HOME/.cache/lm-studio/bin
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
                  
                  theme_gruvbox dark
                  if set -q GHOSTTY_RESOURCES_DIR
                    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
                  end
                  zoxide init fish | source
                  source ~/.orbstack/shell/init2.fish 2>/dev/null || true
                  
                  # Zellij auto-start for Ghostty
                  if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"
                    exec zellij
                  end
                  
                  # Fisher and plugins
                  if not functions -q fisher
                    # Install fisher if not present
                    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
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
                };
                plugins = [
                  { name = "grc";     src = pkgs.fishPlugins.grc; }
                  { name = "z";       src = pkgs.fishPlugins.z; }
                  { name = "hydro";   src = pkgs.fishPlugins.hydro; }
                  { name = "gruvbox"; src = pkgs.fishPlugins.gruvbox; }
                ];
              };

              programs.git = {
                enable = true;
                userName  = "ludwig";
                userEmail = "gogopex@gmail.com";
              };


              programs.btop = {
                enable = true;
                settings = {
                  color_theme = "Default";
                  theme_background = true;
                  truecolor = true;
                  force_tty = false;
                  presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
                  vim_keys = false;
                  rounded_corners = true;
                  graph_symbol = "braille";
                  graph_symbol_cpu = "default";
                  graph_symbol_mem = "default";
                  graph_symbol_net = "default";
                  graph_symbol_proc = "default";
                  shown_boxes = "cpu mem proc net";
                  update_ms = 2000;
                  proc_sorting = "memory";
                  proc_reversed = false;
                  proc_tree = false;
                  proc_colors = true;
                  proc_gradient = true;
                  proc_per_core = false;
                  proc_mem_bytes = true;
                  proc_cpu_graphs = true;
                  proc_info_smaps = false;
                  proc_left = false;
                  proc_filter_kernel = false;
                  proc_aggregate = false;
                  cpu_graph_upper = "Auto";
                  cpu_graph_lower = "Auto";
                  cpu_invert_lower = true;
                  cpu_single_graph = false;
                  cpu_bottom = false;
                  show_uptime = true;
                  check_temp = true;
                  cpu_sensor = "Auto";
                  show_coretemp = true;
                  cpu_core_map = "";
                  temp_scale = "celsius";
                  base_10_sizes = false;
                  show_cpu_freq = true;
                  clock_format = "%X";
                  background_update = true;
                  custom_cpu_name = "";
                  disks_filter = "";
                  mem_graphs = true;
                  mem_below_net = false;
                  zfs_arc_cached = true;
                  show_swap = true;
                  swap_disk = true;
                  show_disks = true;
                  only_physical = true;
                  use_fstab = true;
                  zfs_hide_datasets = false;
                  disk_free_priv = false;
                  show_io_stat = true;
                  io_mode = false;
                  io_graph_combined = false;
                  io_graph_speeds = "";
                  net_download = 100;
                  net_upload = 100;
                  net_auto = true;
                  net_sync = false;
                  net_iface = "";
                  show_battery = true;
                  selected_battery = "Auto";
                  show_battery_watts = true;
                  log_level = "WARNING";
                };
              };

              programs.aerospace = darwinOnly {
                enable = true;
                userSettings = {
                  default-root-container-layout = "tiles";
                  default-root-container-orientation = "auto";
                  accordion-padding = 0;
                  automatically-unhide-macos-hidden-apps = true;
                  gaps.inner.horizontal = 0;
                  gaps.inner.vertical   = 0;
                  gaps.outer = {
                    left = 0; right = 0;
                    top  = 0; bottom = 0;
                  };

                  mode.main.binding = {
                    "cmd-opt-h" = "focus left";
                    "cmd-opt-j" = "focus down";
                    "cmd-opt-k" = "focus up";
                    "cmd-opt-l" = "focus right";
                    "cmd-opt-shift-h" = "move left";
                    "cmd-opt-shift-j" = "move down";
                    "cmd-opt-shift-k" = "move up";
                    "cmd-opt-shift-l" = "move right";
                    "cmd-opt-v" = "join-with right";
                    "cmd-opt-b" = "join-with down";
                    "cmd-opt-tab" = "focus-back-and-forth";
                  };
                };
              };
            };
          })
      ];
    };
  };
}
