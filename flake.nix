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
    zjstatus.url     = "github:dj95/zjstatus";
    # zen-browser.url  = "github:youwen5/zen-browser-flake";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, agenix, ghosttySrc, zjstatus, ... }:
  let
    system = "aarch64-darwin";
    pkgs   = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
  in
  {
    packages.${system}.default = pkgs.hello;

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
            home-manager.extraSpecialArgs = { inherit ghosttySrc zjstatus; };

            home-manager.users.ludwig = { pkgs, lib, ghosttySrc, zjstatus, ... }: let
              darwinOnly = lib.mkIf pkgs.stdenv.isDarwin;
              
              commonEditorSettings = {
                "editor.fontFamily" = "'TX-02-Regular', monospace";
                "editor.fontSize" = 16;
                "editor.lineNumbers" = "on";
                "editor.wordWrap" = "off";
                "editor.insertSpaces" = false;
                "editor.tabSize" = 8;
                "editor.cursorStyle" = "line";
                "editor.inlineSuggest.enabled" = true;
                "editor.formatOnPaste" = true;
                "editor.fontLigatures" = true;
                "terminal.integrated.fontFamily" = "'TX-02-Regular', monospace";
                "terminal.integrated.fontSize" = 16;
                "terminal.integrated.env.osx" = {
                  "NO_ZELLIJ" = "1";
                };
                "github.copilot.enable" = {
                  "*" = false;
                  "plaintext" = false;
                  "markdown" = false;
                  "scminput" = false;
                };
                "explorer.confirmDragAndDrop" = false;
                "remote.SSH.connectTimeout" = 30;
                "remote.SSH.useLocalServer" = false;
              };
            in {
              imports = [ ];
              home.stateVersion = "25.05";
              home.file.".hammerspoon".source = cfg + "/hammerspoon";
              home.file.".ideavimrc".source = cfg + "/ideavimrc";

              xdg.configFile."nvim".source              = cfg + "/nvim";
              # xdg.configFile."zen/distribution/policies.json".source = cfg + "/zen/policies.json";
              

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
                  window-decoration        = "none";
                  window-save-state        = "always";
                  auto-update              = "off";
                  keybind = [
                    "shift+return=text:\x1b\r"
                    "ctrl+space=toggle_fullscreen"
                    "cmd+shift+t=new_tab"
                    "ctrl+h=unbind"   "ctrl+j=unbind"
                    "ctrl+k=unbind"   "ctrl+l=unbind"
                    "cmd+h=unbind"    "cmd+l=unbind"
                    "cmd+t=unbind"    "cmd+w=unbind"
                    "cmd+d=unbind"    "cmd+shift+d=unbind"
                    "cmd+shift+w=unbind"
                    "cmd+ctrl+h=unbind"
                    "cmd+ctrl+j=unbind"
                    "cmd+ctrl+k=unbind"
                    "cmd+ctrl+l=unbind"
                    "cmd+ctrl+shift+h=unbind"
                    "cmd+ctrl+shift+l=unbind"
                    "global:shift+opt+t=toggle_quick_terminal"
                  ];
                };
              };

              programs.zellij = {
                enable = true;
                enableFishIntegration = true;
                settings = {
                  theme = "gruvbox-dark";
                };
              };
              
              xdg.configFile."zellij/config.kdl".text = ''
                // Zellij configuration with zjstatus notifications
                simplified_ui true
                default_shell "fish"
                theme "gruvbox-dark"
                copy_command "pbcopy"
                copy_on_select true
                show_startup_tips false
                
                // session management
                session_serialization true
                pane_viewport_serialization true
                scrollback_lines_to_serialize 10000
                serialization_interval 60
                
                // plugins
                # plugins {
                #     zjstatus location="file:${zjstatus.packages.${system}.default}/bin/zjstatus.wasm" {
                #         // format for notifications and status
                #         format_left  "#[fg=#689d6a,bold]#[bg=#3c3836] {mode}#[bg=#689d6a,fg=#1d2021,bold] {session} "
                #         format_center "#[fg=#ddc7a1,bg=#3c3836]{tabs}"
                #         format_right "#[fg=#ddc7a1,bg=#3c3836] {notifications}#[fg=#689d6a,bg=#3c3836] {datetime}"
                #         format_space "#[bg=#1d2021]"
                #         format_hide_on_overlength true
                #         format_precedence "crl"
                
                #         // notification settings for Claude Code sessions and commands
                #         notification_format_unread           "#[fg=#d79921,bold]●"
                #         notification_format_no_notifications "#[fg=#504945]○"
                        
                #         // tab formatting with bell alerts
                #         tab_normal               "#[fg=#6C7086] {name} "
                #         tab_normal_fullscreen    "#[fg=#6C7086] {name}[] "
                #         tab_normal_sync          "#[fg=#6C7086] {name}<> "
                #         tab_active               "#[fg=#9ECE6A,bold] {name} "
                #         tab_active_fullscreen    "#[fg=#9ECE6A,bold] {name}[] "
                #         tab_active_sync          "#[fg=#9ECE6A,bold] {name}<> "
                        
                #         tab_bell                 "#[fg=#F7768E,bold]!{name} "
                #         tab_bell_fullscreen      "#[fg=#F7768E,bold]!{name}[] "
                #         tab_bell_sync            "#[fg=#F7768E,bold]!{name}<> "
                
                #         // mode indicators
                #         mode_normal        "#[fg=#689d6a,bold] NORMAL"
                #         mode_locked        "#[fg=#d79921,bold] LOCKED"
                #         mode_resize        "#[fg=#d3869b,bold] RESIZE"
                #         mode_pane          "#[fg=#458588,bold] PANE"
                #         mode_tab           "#[fg=#b16286,bold] TAB"
                #         mode_scroll        "#[fg=#689d6a,bold] SCROLL"
                #         mode_enter_search  "#[fg=#d79921,bold] SEARCH"
                #         mode_search        "#[fg=#d79921,bold] SEARCH"
                #         mode_rename_tab    "#[fg=#b16286,bold] RENAME"
                #         mode_rename_pane   "#[fg=#458588,bold] RENAME"
                #         mode_session       "#[fg=#d3869b,bold] SESSION"
                #         mode_move          "#[fg=#d79921,bold] MOVE"
                #         mode_prompt        "#[fg=#689d6a,bold] PROMPT"
                #         mode_tmux          "#[fg=#98971a,bold] TMUX"
                
                #         // datetime
                #         datetime        "#[fg=#6C7086,bold] {format} "
                #         datetime_format "%A, %d %b %Y %H:%M"
                #         datetime_timezone "America/New_York"
                #     }
                }
                
                ui {
                    pane_frames {
                        hide_session_name true
                    }
                }
                
                keybinds {
                    normal {
                        // tab navigation 
                        bind "Super h" { GoToPreviousTab; }
                        bind "Super l" { GoToNextTab; }
                        bind "Super t" { NewTab; }
                        bind "Super w" { CloseTab; }
                        
                        // pane navigation 
                        bind "Ctrl h" { MoveFocus "Left"; }
                        bind "Ctrl j" { MoveFocus "Down"; }
                        bind "Ctrl k" { MoveFocus "Up"; }
                        bind "Ctrl l" { MoveFocus "Right"; }
                        
                        // pane resizing
                        bind "Super Ctrl h" { Resize "Increase Left"; }
                        bind "Super Ctrl j" { Resize "Increase Down"; }
                        bind "Super Ctrl k" { Resize "Increase Up"; }
                        bind "Super Ctrl l" { Resize "Increase Right"; }
                        
                        // pane management
                        bind "Super d" { NewPane "Right"; }
                        bind "Super Shift d" { NewPane "Down"; }
                        bind "Super Shift w" { CloseFocus; }
                        
                        // pane movement
                        bind "Super Shift h" { MovePane "Left"; }
                        bind "Super Shift j" { MovePane "Down"; }
                        bind "Super Shift k" { MovePane "Up"; }
                        bind "Super Shift l" { MovePane "Right"; }
                        
                        // stacked panes management (swap layouts)
                        bind "Super b" { NextSwapLayout; }
                        bind "Super Shift b" { PreviousSwapLayout; }
                        
                        // fullscreen and frames
                        bind "Super f" { ToggleFocusFullscreen; }
                        bind "Super z" { TogglePaneFrames; }
                        
                        // tab movement
                        bind "Super Ctrl Shift h" { MoveTab "Left"; }
                        bind "Super Ctrl Shift l" { MoveTab "Right"; }
                        
                        // mode switching
                        bind "Ctrl a" { SwitchToMode "Tmux"; }
                        bind "Super s" { SwitchToMode "Session"; }
                        
                        // @TODO: this still opens a tab, maybe overlaps with smth
                        // direct session switching
                        // bind "Super Shift 1" {
                        //     NewPane {
                        //         direction "Down"
                        //         command "fish"
                        //         args "-c" "zmain"
                        //         floating true
                        //         close_on_exit true
                        //     }
                        // }
                        // bind "Super Shift 2" {
                        //     NewPane {
                        //         direction "Down"
                        //         command "fish"
                        //         args "-c" "zwork"
                        //         floating true
                        //         close_on_exit true
                        //     }
                        // }
                        
                        // @TODO: this still opens a tab, maybe overlaps with smth
                        // tab fuzzy finder
                        // bind "Super /" { 
                        //     NewPane {
                        //         direction "Down";
                        //         command "fish";
                        //         args "-c" "zellij_tab_switcher";
                        //         floating true;
                        //         close_on_exit true;
                        //     }
                        // }
                        
                        // essential shortcuts
                        bind "Ctrl q" { Quit; }
                        bind "Ctrl g" { SwitchToMode "Locked"; }
                        bind "Ctrl Shift e" { EditScrollback; }
                    }
                
                    locked {
                        bind "Ctrl g" { SwitchToMode "Normal"; }
                    }
                
                    scroll {
                        bind "h" { MoveFocus "Left"; }
                        bind "j" { ScrollDown; }
                        bind "k" { ScrollUp; }
                        bind "l" { MoveFocus "Right"; }
                        bind "Ctrl f" { PageScrollDown; }
                        bind "Ctrl b" { PageScrollUp; }
                        bind "d" { HalfPageScrollDown; }
                        bind "u" { HalfPageScrollUp; }
                        bind "e" { EditScrollback; }
                        bind "q" { SwitchToMode "Normal"; }
                        bind "Esc" { SwitchToMode "Normal"; }
                        bind "Ctrl c" { SwitchToMode "Normal"; }
                        bind "/" { SwitchToMode "EnterSearch"; }
                        bind "n" { Search "down"; }
                        bind "N" { Search "up"; }
                    }
                }
              '';

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
                    auto-completion = true; # disable autocomplete by default
                    completion-trigger-len = 0; # don't auto-trigger
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
                  mgr = { show_hidden = true; sort_by = "mtime"; };
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
                  mutagen
                  obsidian uutils-coreutils-noprefix
                  dust hyperfine just tldr glow lazygit procs git-recent
                  tailscale gh
                  # Lean toolchain
                  elan
                  # Zed editor
                  # zed-editor
                ] ++ lib.optionals pkgs.stdenv.isDarwin [ zotero ]
              );

              programs.go.enable = true;

              # programs.zed-editor = darwinOnly {
              #   enable = true;
              #   
              #   userSettings = {
              #     # Editor behavior
              #     vim_mode = true;
              #     telemetry = {
              #       metrics = false;
              #       diagnostics = false;
              #     };
              #     
              #     # UI/Font
              #     ui_font_size = 16;
              #     buffer_font_size = 16;
              #     ui_font_family = "TX-02";
              #     buffer_font_family = "TX-02-Regular";
              #     theme = "Gruvbox Dark";
              #     
              #     # Features  
              #     features = {
              #       copilot = false;
              #     };
              #     
              #     # Behavior
              #     auto_update = false;
              #     confirm_quit = true;
              #     restore_on_startup = "last_workspace";
              #   };
              #   
              #   userKeymaps = [
              #     # Vim mode enhancements (matches your existing patterns)
              #     {
              #       context = "Editor && VimControl && !VimWaiting && !menu";
              #       bindings = {
              #         "g h" = ["vim::StartOfLine"];
              #         "g l" = ["vim::EndOfLine"];
              #         "space y" = ["editor::Copy"];
              #         "space d" = ["vim::Substitute" {"target" = "Selected";} "d" "\"_d"];
              #         "space h" = ["search::ClearSearchResults"];
              #       };
              #     }
              #     
              #     # Visual mode (matches your existing patterns)
              #     {
              #       context = "Editor && vim_mode == visual && !VimWaiting && !menu";
              #       bindings = {
              #         "shift-j" = ["editor::MoveLineDown"];
              #         "shift-k" = ["editor::MoveLineUp"];
              #         "<" = ["editor::Outdent"];
              #         ">" = ["editor::Indent"];
              #         "g h" = ["vim::StartOfLine"];
              #         "g l" = ["vim::EndOfLine"];
              #         "space y" = ["editor::Copy"];
              #         "space d" = ["vim::Substitute" {"target" = "Selected";} "d" "\"_d"];
              #       };
              #     }
              #     
              #     # Workspace - unified with Zellij/Helix patterns
              #     {
              #       context = "Workspace";
              #       bindings = {
              #         # File/Project management (matches Helix space patterns)
              #         "space f" = ["file_finder::Toggle"];  # File finder
              #         "space e" = ["workspace::ToggleLeftDock"];  # File explorer (matches cmd-e)
              #         "space b" = ["tab_switcher::Toggle"];  # Buffer/tab switcher
              #         
              #         # AI Assistant (new unified pattern)
              #         "space a c" = ["assistant::ToggleFocus"];  # AI Chat toggle  
              #         "space a i" = ["assistant::InlineAssist"];  # Quick AI input/inline
              #         "space a a" = ["agent::NewThread"];  # Agent panel
              #         
              #         # Pane management (matches Zellij patterns exactly)
              #         "cmd-h" = ["pane::ActivatePrevItem"];    # Tab navigation (matches Zellij)
              #         "cmd-l" = ["pane::ActivateNextItem"];    # Tab navigation (matches Zellij)
              #         "cmd-t" = ["workspace::NewFile"];       # New tab (matches Zellij)
              #         "cmd-w" = ["pane::CloseActiveItem"];     # Close tab (matches Zellij)
              #         
              #         # Pane focus navigation (matches AeroSpace cmd+opt pattern)
              #         "cmd-opt-h" = ["workspace::ActivatePaneInDirection" "Left"];
              #         "cmd-opt-j" = ["workspace::ActivatePaneInDirection" "Down"];
              #         "cmd-opt-k" = ["workspace::ActivatePaneInDirection" "Up"];
              #         "cmd-opt-l" = ["workspace::ActivatePaneInDirection" "Right"];
              #         
              #         # Pane splitting (matches Zellij exactly)
              #         "cmd-d" = ["pane::SplitRight"];         # Split right (matches Zellij)
              #         "cmd-shift-d" = ["pane::SplitDown"];    # Split down (matches Zellij) 
              #         "cmd-shift-w" = ["pane::ClosePane"];    # Close pane (matches Zellij)
              #         
              #         # Search (Helix pattern)
              #         "space /" = ["search::ToggleReplace"];
              #         "space s" = ["project_search::ToggleFocus"];  # Project search
              #         
              #         # Terminal (Helix/Zellij pattern)
              #         "space t" = ["terminal_panel::ToggleFocus"];
              #         
              #         # Diagnostics/Git (Helix patterns)
              #         "space g" = ["editor::ToggleGitBlame"];
              #         "space d" = ["diagnostics::Deploy"];
              #       };
              #     }
              #   ];
              #   
              #   extensions = [
              #     "nix"
              #     "swift"
              #     "rust"
              #     "python"
              #     "json"
              #     "toml"
              #     "markdown"
              #   ];
              # };

              programs.vscode = {
                enable = true;
                profiles.default.userSettings = commonEditorSettings // {
                  # VS Code specific settings
                  "workbench.colorTheme" = "Gruvbox Dark Hard";
                  "window.zoomLevel" = 0.8;
                  "editor.fontSize" = 15;
                  "git.enableSmartCommit" = true;
                  "files.exclude" = {
                    "**/.DS_Store" = true;
                    "**/.git" = true;
                    "**/.hg" = true;
                    "**/.svn" = true;
                    "**/*.js" = {
                      "when" = "$(basename).ts";
                    };
                    "**/**.js" = {
                      "when" = "$(basename).tsx";
                    };
                    "**/app/cache/**" = true;
                    "**/CVS" = true;
                    "app/cache/**" = true;
                  };
                  "workbench.editor.enablePreviewFromQuickOpen" = false;
                  "breadcrumbs.enabled" = true;
                  "search.useIgnoreFiles" = false;
                  "explorer.confirmDelete" = false;
                  "emmet.triggerExpansionOnTab" = true;
                  "emmet.syntaxProfiles" = {
                    "html" = {
                      "filters" = "bem";
                    };
                  };
                  "diffEditor.ignoreTrimWhitespace" = false;
                  "[javascript]" = {
                    "editor.defaultFormatter" = "vscode.typescript-language-features";
                  };
                  "files.eol" = "\n";
                  "files.insertFinalNewline" = true;
                  "files.trimFinalNewlines" = true;
                  "twig-language-2.bracePadding" = true;
                  "twig-language-2.spaceClose" = true;
                  "liveshare.presence" = true;
                  "intelephense.environment.phpVersion" = "7.4.13";
                  "php.suggest.basic" = false;
                  "[php]" = {
                    "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
                    "editor.formatOnSave" = true;
                  };
                  "emmet.includeLanguages" = {
                    "twig" = "html";
                  };
                  "search.exclude" = {
                    "**/app/cache" = true;
                    "**/app/logs" = true;
                    "**/node_modules/**" = true;
                    "**/var/cache" = true;
                    "**/var/logs" = true;
                    "**/web" = true;
                    "app/cache/*.xml" = true;
                    "app/cache/**" = true;
                  };
                  "files.watcherExclude" = {
                    "**/app/cache/**" = true;
                    "**/var/cache/**" = true;
                    "**/var/logs/**" = true;
                    "**/node_modules/**" = true;
                    "**/.venv/**" = true;
                  };
                  "rust-analyzer.checkOnSave.command" = "clippy";
                  "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
                  "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";
                  "editor.defaultFormatter" = "kokororin.vscode-phpfmt";
                  "editor.wordSeparators" = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
                  "github.copilot.enable" = {
                    "*" = false;
                    "plaintext" = true;
                    "markdown" = false;
                    "scminput" = false;
                    "yaml" = false;
                    "rust" = true;
                    "php" = true;
                    "python" = true;
                    "uiua" = false;
                  };
                  "[python]" = {
                    "editor.defaultFormatter" = "ms-python.python";
                    "editor.formatOnType" = true;
                  };
                  "workbench.editor.highlightModifiedTabs" = true;
                  "workbench.editor.wrapTabs" = true;
                  "security.promptForLocalFileProtocolHandling" = false;
                  "makefile.configureOnOpen" = true;
                  "editor.columnSelection" = true;
                  "terminal.external.osxExec" = "Ghostty.app";
                  "terminal.integrated.fontLigatures.enabled" = true;
                  "extensions.experimental.affinity" = {
                    "asvetliakov.vscode-neovim" = 1;
                  };
                  "jupyter.askForKernelRestart" = false;
                  "chat.commandCenter.enabled" = false;
                  "remote.SSH.showLoginTerminal" = true;
                  "remote.SSH.useExecServer" = true;
                  "remote.SSH.remotePlatform" = {
                    "38.97.6.9" = "linux";
                    "bigdave" = "linux";
                  };
                  "workbench.startupEditor" = "none";
                  "amp.url" = "https://ampcode.com/";
                };
              };

              # Cursor IDE settings
              home.file."Library/Application Support/Cursor/User/settings.json".text = builtins.toJSON (commonEditorSettings // {
                # Cursor specific settings
                "workbench.colorTheme" = "Gruvbox Dark Soft";
                "editor.fontSize" = 18;
                "terminal.integrated.fontSize" = 18;
                "chat.editor.fontSize" = 16;
                "extensions.experimental.affinity" = {
                  "asvetliakov.vscode-neovim" = 1;
                };
                "cursor.composer.collapsePaneInputBoxPills" = true;
                "cursor.composer.renderPillsInsteadOfBlocks" = true;
                "git.confirmSync" = false;
                "cursor.composer.cmdPFilePicker2" = true;
                "cursor.terminal.usePreviewBox" = true;
                "go.toolsManagement.autoUpdate" = true;
                "remote.SSH.path" = "/opt/homebrew/bin/ssh";
                "remote.SSH.remotePlatform" = {
                  "bigdave" = "linux";
                };
                "remote.SSH.enableDynamicForwarding" = false;
                "remote.SSH.enableAgentForwarding" = false;
                "gitlens.home.preview.enabled" = false;
                "update.releaseTrack" = "prerelease";
                "cursor.composer.textSizeScale" = 1.15;
                "cursor.composer.shouldAllowCustomModes" = true;
                "cursor.cpp.enablePartialAccepts" = true;
                "clangd.detectExtensionConflicts" = false;
                "cursor.composer.shouldChimeAfterChatFinishes" = true;
                "lldb.suppressUpdateNotifications" = true;
                "lean4.alwaysAskBeforeInstallingLeanVersions" = false;
                "terminal.integrated.shell.osx" = "/run/current-system/sw/bin/fish";
                "terminal.integrated.automationShell.osx" = "/run/current-system/sw/bin/fish";
              });

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
                  merge.conflictStyle = "zdiff3";
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
                  vim_keys = true;
                  rounded_corners = true;
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
                    
                    # window movement: Cmd + Opt + Shift + hjkl
                    "cmd-opt-shift-h" = "move left";
                    "cmd-opt-shift-j" = "move down";
                    "cmd-opt-shift-k" = "move up";
                    "cmd-opt-shift-l" = "move right";
                    
                    
                    # window resizing
                    "cmd-opt-shift-u" = "resize smart -50";
                    "cmd-opt-shift-i" = "resize smart +50";
                    
                    # window splits
                    "cmd-opt-shift-y" = "join-with right";
                    "cmd-opt-shift-o" = "join-with down";
                    
                    # layout management
                    "cmd-opt-shift-n" = "layout toggle floating tiling";
                    "cmd-opt-shift-m" = "layout tiles";
                    
                    # focus management
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
