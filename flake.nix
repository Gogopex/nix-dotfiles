{
  description = "macOS dev environment";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-darwin.url   = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ghosttySrc.url   = "github:ghostty-org/ghostty";
    agenix.url       = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-darwin, home-manager, agenix, ghosttySrc, ... }:
  let
    system = "aarch64-darwin";
    pkgs   = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
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

        ({ config, pkgs, ... }: let
            leader = "C-Space";
            cfg    = ./cfg;                
          in {
            # glue: make HM see the host-level pkgs & args
            users.users.ludwig.home = "/Users/ludwig";
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit ghosttySrc; };

            home-manager.users.ludwig = { pkgs, lib, ghosttySrc, ... }: let
              darwinOnly = lib.mkIf pkgs.stdenv.isDarwin;
            in {
              imports = [ ];
              home.stateVersion = "25.05";
              home.file.".hammerspoon".source = cfg + "/hammerspoon";
              home.file.".ideavimrc".source = cfg + "/ideavimrc";

              xdg.configFile."nvim".source              = cfg + "/nvim";
              

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
                    "shift+enter=text:\n"
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
                  
                  # session management
                  session_serialization = true;
                  pane_viewport_serialization = true;
                  scrollback_lines_to_serialize = 10000;
                  serialization_interval = 60;
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
                      
                      # session management
                      "bind \"Super s\"" = { SwitchToMode = "Session"; };
                      
                      # quick layout switching
                      "bind \"Super 1\"" = { NewTab = { layout = "dev"; }; };
                      "bind \"Super 2\"" = { NewTab = { layout = "monitoring"; }; };
                      "bind \"Super 3\"" = { NewTab = { layout = "research"; }; };
                      
                      # essential shortcuts
                      "bind \"Ctrl q\"" = { Quit = {}; };
                      "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
                      
                      # direct scrollback editing (no scroll mode needed)
                      "bind \"Ctrl-Shift-e\"" = { EditScrollback = {}; };
                    };

                    locked = {
                      "bind \"Ctrl g\"" = { SwitchToMode = "Normal"; };
                    };

                    scroll = {
                      # vim-like navigation
                      "bind \"h\"" = { MoveFocus = "Left"; };
                      "bind \"j\"" = { ScrollDown = {}; };
                      "bind \"k\"" = { ScrollUp = {}; };
                      "bind \"l\"" = { MoveFocus = "Right"; };
                      
                      # page navigation
                      "bind \"Ctrl f\"" = { PageScrollDown = {}; };
                      "bind \"Ctrl b\"" = { PageScrollUp = {}; };
                      "bind \"d\"" = { HalfPageScrollDown = {}; };
                      "bind \"u\"" = { HalfPageScrollUp = {}; };
                      
                      # open scrollback in editor for visual selection/copying
                      "bind \"e\"" = { EditScrollback = {}; };
                      
                      # exit scroll mode
                      "bind \"q\"" = { SwitchToMode = "Normal"; };
                      "bind \"Esc\"" = { SwitchToMode = "Normal"; };
                      "bind \"Ctrl c\"" = { SwitchToMode = "Normal"; };
                      
                      # search
                      "bind \"/\"" = { SwitchToMode = "EnterSearch"; };
                      "bind \"n\"" = { Search = "down"; };
                      "bind \"N\"" = { Search = "up"; };
                    };
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
                    monitoring = {
                      panes = [
                        {
                          direction = "Right";
                          size = "50%";
                          panes = [
                            { run = "btop"; }
                            { run = "procs"; }
                          ];
                        }
                        {
                          direction = "Down";
                          panes = [
                            { run = "tail -f /var/log/system.log"; }
                            { }
                          ];
                        }
                      ];
                    };
                    research = {
                      panes = [
                        { }
                        {
                          direction = "Right";
                          size = "40%";
                          panes = [
                            { run = "hx"; }
                            { }
                          ];
                        }
                      ];
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
                    line-number = "absolute";              
                    auto-completion = false;               # disable autocomplete by default
                    completion-trigger-len = 0;            # don't auto-trigger
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
                      
                      # manual completion trigger
                      "C-space" = "completion";
                      
                      # autocomplete toggle commands
                      "space" = {
                        "u" = {
                          "c" = ":set editor.auto-completion true";   # space+u+c = enable
                          "C" = ":set editor.auto-completion false";  # space+u+C = disable
                        };
                      };
                      
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
                      "C-S-A-c" = "copy_selection_on_next_line";
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

              # obsidian declarative module (testing)
              # programs.obsidian = {
              #   enable = true;
              #   vaultPath = "/Users/ludwig/obsidian_vaults/personal";
              #   
              #   settings = {
              #     vimMode = true;
              #     theme = "obsidian";  # dark theme
              #     cssTheme = "LessWrong";
              #     baseFontSize = 18;
              #     accentColor = "#5359fd";
              #     monospaceFontFamily = "TX-02";
              #     alwaysUpdateLinks = true;
              #     attachmentFolderPath = "Attachments";
              #     promptDelete = false;
              #   };
              #   
              #   plugins = {
              #     "readwise-official" = {
              #       url = "https://github.com/readwiseio/obsidian-readwise/archive/refs/tags/3.0.1.tar.gz";
              #       sha256 = "126y495yhk12j5piqn95yn1p1v9058si0mwcbrdfgb8vwrl4ymhj";
              #     };
              #     "smart-composer" = {
              #       url = "https://github.com/glowingjade/obsidian-smart-composer/archive/refs/tags/1.2.1.tar.gz";
              #       sha256 = "1r0pvavzl7rmvdmhc96w7zwmxi7s4mmzpac44jrr5w4g6ynqw3ik";
              #     };
              #     "better-word-count" = {
              #       url = "https://github.com/lukeleppan/better-word-count/archive/refs/tags/0.9.5.tar.gz";
              #       sha256 = "1lpz1gp0w6by39dxl48jkqshv6cg8g2rr8rpar504qifv31zbvgv";
              #     };
              #   };
              # };

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
                  nixfmt-rfc-style nil volta nodejs maven openjdk wiki-tui tokei
                  agenix.packages.${system}.default
                  mutagen mutagen-compose
                  obsidian uutils-coreutils-noprefix
                  dust hyperfine just tldr glow lazygit procs git-recent
                  tailscale gh
                  # Lean toolchain
                  elan
                  # Zed editor
                  zed-editor
                ] ++ lib.optionals pkgs.stdenv.isDarwin [ zotero ]
              );

              programs.go.enable = true;

              programs.zed-editor = darwinOnly {
                enable = true;
                
                userSettings = {
                  # Editor behavior
                  vim_mode = true;
                  telemetry = {
                    metrics = false;
                    diagnostics = false;
                  };
                  
                  # UI/Font
                  ui_font_size = 16;
                  buffer_font_size = 16;
                  ui_font_family = "TX-02";
                  buffer_font_family = "TX-02-Regular";
                  theme = "Gruvbox Dark";
                  
                  # Features  
                  features = {
                    copilot = false;
                  };
                  
                  # Behavior
                  auto_update = false;
                  confirm_quit = true;
                  restore_on_startup = "last_workspace";
                };
                
                userKeymaps = [
                  # Vim mode enhancements (matches your existing patterns)
                  {
                    context = "Editor && VimControl && !VimWaiting && !menu";
                    bindings = {
                      "g h" = ["vim::StartOfLine"];
                      "g l" = ["vim::EndOfLine"];
                      "space y" = ["editor::Copy"];
                      "space d" = ["vim::Substitute" {"target" = "Selected";} "d" "\"_d"];
                      "space h" = ["search::ClearSearchResults"];
                    };
                  }
                  
                  # Visual mode (matches your existing patterns)
                  {
                    context = "Editor && vim_mode == visual && !VimWaiting && !menu";
                    bindings = {
                      "shift-j" = ["editor::MoveLineDown"];
                      "shift-k" = ["editor::MoveLineUp"];
                      "<" = ["editor::Outdent"];
                      ">" = ["editor::Indent"];
                      "g h" = ["vim::StartOfLine"];
                      "g l" = ["vim::EndOfLine"];
                      "space y" = ["editor::Copy"];
                      "space d" = ["vim::Substitute" {"target" = "Selected";} "d" "\"_d"];
                    };
                  }
                  
                  # Workspace - unified with Zellij/Helix patterns
                  {
                    context = "Workspace";
                    bindings = {
                      # File/Project management (matches Helix space patterns)
                      "space f" = ["file_finder::Toggle"];  # File finder
                      "space e" = ["workspace::ToggleLeftDock"];  # File explorer (matches cmd-e)
                      "space b" = ["tab_switcher::Toggle"];  # Buffer/tab switcher
                      
                      # AI Assistant (new unified pattern)
                      "space a c" = ["assistant::ToggleFocus"];  # AI Chat toggle  
                      "space a i" = ["assistant::InlineAssist"];  # Quick AI input/inline
                      "space a a" = ["agent::NewThread"];  # Agent panel
                      
                      # Pane management (matches Zellij patterns exactly)
                      "cmd-h" = ["pane::ActivatePrevItem"];    # Tab navigation (matches Zellij)
                      "cmd-l" = ["pane::ActivateNextItem"];    # Tab navigation (matches Zellij)
                      "cmd-t" = ["workspace::NewFile"];       # New tab (matches Zellij)
                      "cmd-w" = ["pane::CloseActiveItem"];     # Close tab (matches Zellij)
                      
                      # Pane focus navigation (matches AeroSpace cmd+opt pattern)
                      "cmd-opt-h" = ["workspace::ActivatePaneInDirection" "Left"];
                      "cmd-opt-j" = ["workspace::ActivatePaneInDirection" "Down"];
                      "cmd-opt-k" = ["workspace::ActivatePaneInDirection" "Up"];
                      "cmd-opt-l" = ["workspace::ActivatePaneInDirection" "Right"];
                      
                      # Pane splitting (matches Zellij exactly)
                      "cmd-d" = ["pane::SplitRight"];         # Split right (matches Zellij)
                      "cmd-shift-d" = ["pane::SplitDown"];    # Split down (matches Zellij) 
                      "cmd-shift-w" = ["pane::ClosePane"];    # Close pane (matches Zellij)
                      
                      # Search (Helix pattern)
                      "space /" = ["search::ToggleReplace"];
                      "space s" = ["project_search::ToggleFocus"];  # Project search
                      
                      # Terminal (Helix/Zellij pattern)
                      "space t" = ["terminal_panel::ToggleFocus"];
                      
                      # Diagnostics/Git (Helix patterns)
                      "space g" = ["editor::ToggleGitBlame"];
                      "space d" = ["diagnostics::Deploy"];
                    };
                  }
                ];
                
                extensions = [
                  "nix"
                  "swift"
                  "rust"
                  "python"
                  "json"
                  "toml"
                  "markdown"
                ];
              };

              programs.fish = {
                enable = true;
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

                  # nvm initialization (install if not present)
                  if not test -d ~/.nvm
                    echo "Installing nvm..."
                    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                  end
                  if test -d ~/.nvm
                    set -gx NVM_DIR ~/.nvm
                  end

                  # volta initialization
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
                  
                  # Enable vi mode by default with enhanced bindings and Berkeley Mono styling
                  fish_vi_key_bindings
                  setup_enhanced_vi_mode
                  
                  # Set Berkeley Mono cursor shapes for better vim mode experience
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
                  
                  # Zellij auto-start for Ghostty (without exec to avoid shell replacement issues)
                  if test "$TERM" = "xterm-ghostty"; and test -z "$ZELLIJ"
                    if command -v zellij >/dev/null 2>&1
                      zellij
                    end
                  end
                  
                  # Fisher and plugins
                  if not functions -q fisher
                    # Install fisher if not present
                    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
                  end
                  
                  # Create fish_user_key_bindings function for persistent keybinds
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
                  
                  # Custom mode prompt with Berkeley Mono characters
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
                  
                  # Nix shell detection with creative Berkeley Mono indicators
                  nix_shell_prompt = ''
                    function nix_shell_prompt
                      if test -n "$IN_NIX_SHELL"
                        set_color -o brcyan
                        echo -n "◉ nix "
                        set_color normal
                      end
                    end
                  '';
                  
                  # Enhanced right prompt that includes nix shell info (doesn't interfere with hydro)
                  fish_right_prompt = ''
                    function fish_right_prompt
                      nix_shell_prompt
                    end
                  '';
                  
                  setup_enhanced_vi_mode = ''
                    function setup_enhanced_vi_mode
                      # Set Berkeley Mono-friendly cursor shapes
                      set -g fish_cursor_default block
                      set -g fish_cursor_insert line
                      set -g fish_cursor_replace_one underscore
                      set -g fish_cursor_replace underscore
                      set -g fish_cursor_external line
                      set -g fish_cursor_visual block
                      
                      # Visual line selection with Shift+V (in normal mode)
                      bind -M default V 'commandline -f beginning-of-line visual-mode end-of-line'
                      
                      # Home/End shortcuts with gh/gl (in normal mode)
                      bind -M default gh 'commandline -f beginning-of-line'
                      bind -M default gl 'commandline -f end-of-line'
                      
                      # Additional useful vi shortcuts
                      bind -M default gg 'commandline -f beginning-of-buffer'
                      bind -M default G 'commandline -f end-of-buffer'
                      
                      # Make these work in visual mode too
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
                extraConfig = {
                  pull.rebase = false;
                  init.defaultBranch = "main";
                  push.autoSetupRemote = true;
                  merge.conflictstyle = "diff3";
                  rebase.autosquash = true;
                  core.pager = "delta";
                  interactive.diffFilter = "delta --color-only";
                  delta = {
                    navigate = true;
                    light = false;
                    line-numbers = true;
                    side-by-side = false;
                    syntax-theme = "gruvbox-dark";
                  };
                  merge.conflictStyle = "diff3";
                  diff.colorMoved = "default";
                };
                aliases = {
                  st = "status";
                  co = "checkout"; 
                  br = "branch";
                  l = "log --oneline --graph --decorate";
                  la = "log --oneline --graph --decorate --all";
                  d = "diff";
                  dc = "diff --cached";
                  a = "add";
                  c = "commit";
                  ca = "commit -a";
                  unstage = "reset HEAD --";
                  last = "log -1 HEAD";
                  visual = "!gitk";
                };
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
                    # Frequent operations: Cmd + Opt + hjkl
                    "cmd-opt-h" = "focus left";
                    "cmd-opt-j" = "focus down";
                    "cmd-opt-k" = "focus up";
                    "cmd-opt-l" = "focus right";
                    
                    # Window movement: Cmd + Opt + Shift + hjkl
                    "cmd-opt-shift-h" = "move left";
                    "cmd-opt-shift-j" = "move down";
                    "cmd-opt-shift-k" = "move up";
                    "cmd-opt-shift-l" = "move right";
                    
                    # Less frequent operations: Cmd + Opt + Shift + right-hand keys
                    
                    # Window resizing
                    "cmd-opt-shift-u" = "resize smart -50";
                    "cmd-opt-shift-i" = "resize smart +50";
                    
                    # Window splits
                    "cmd-opt-shift-y" = "join-with right";
                    "cmd-opt-shift-o" = "join-with down";
                    
                    # Layout management
                    "cmd-opt-shift-n" = "layout toggle floating tiling";
                    "cmd-opt-shift-m" = "layout tiles";
                    
                    # Focus management
                    "cmd-opt-shift-p" = "focus-back-and-forth";
                  };
                };
              };
            };
          })
      ];
    };
  };
}
