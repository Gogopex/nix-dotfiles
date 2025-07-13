{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) enabled merge mkIf;
  zjstatus = inputs.zjstatus or null;
  
  colors = config.theme.colors;
  
  stripHash = color: builtins.substring 1 6 color;
  
  room = pkgs.fetchurl {
    url = "https://github.com/rvcas/room/releases/download/v1.2.0/room.wasm";
    sha256 = "sha256-t6GPP7OOztf6XtBgzhLF+edUU294twnu0y5uufXwrkw=";
  };
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    programs.zellij = enabled {
      enableFishIntegration = false;
      settings = {
        theme = "gruvbox-dark";
      };
    };
    
    xdg.configFile."zellij/config.kdl".text = /* kdl */ ''
      simplified_ui true
      default_shell "fish"
      theme "gruvbox-dark"
      copy_command "pbcopy"
      copy_on_select true
      show_startup_tips false
      
      session_serialization true
      pane_viewport_serialization true
      scrollback_lines_to_serialize 10000
      serialization_interval 60
      
      on_force_close "detach"
      
      ui {
          pane_frames {
              hide_session_name true
          }
      }
      
      keybinds {
          shared_except "locked" {
              bind "Ctrl y" {
                  LaunchOrFocusPlugin "file:${room}" {
                      floating true
                      ignore_case true
                      quick_jump true
                  }
              }
          }
          
          normal {
              bind "Super h" { GoToPreviousTab; }
              bind "Super l" { GoToNextTab; }
              bind "Super t" { NewTab; }
              bind "Super Shift w" { CloseTab; }
              
              // bind "Ctrl h" { MoveFocus "Left"; }
              // bind "Ctrl j" { MoveFocus "Down"; }
              // bind "Ctrl k" { MoveFocus "Up"; }
              // bind "Ctrl l" { MoveFocus "Right"; }
              
              bind "Super Ctrl h" { Resize "Increase Left"; }
              bind "Super Ctrl j" { Resize "Increase Down"; }
              bind "Super Ctrl k" { Resize "Increase Up"; }
              bind "Super Ctrl l" { Resize "Increase Right"; }
              
              bind "Super d" { NewPane "Right"; }
              bind "Super Shift d" { NewPane "Down"; }
              bind "Super w" { CloseFocus; }
              
              bind "Super Shift h" { MovePane "Left"; }
              bind "Super Shift j" { MovePane "Down"; }
              bind "Super Shift k" { MovePane "Up"; }
              bind "Super Shift l" { MovePane "Right"; }
              
              bind "Super b" { NextSwapLayout; }
              bind "Super Shift b" { PreviousSwapLayout; }
              bind "Super e" { TogglePaneEmbedOrFloating; }
              
              bind "Super f" { ToggleFocusFullscreen; }
              bind "Super z" { TogglePaneFrames; }
              
              // bind "Super Ctrl Shift h" { MoveTab "Left"; }
              // bind "Super Ctrl Shift l" { MoveTab "Right"; }
          }
          
          session {
              bind "s" { SwitchToMode "Normal"; }
              bind "d" { Detach; }
              bind "w" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "Normal"
              }
              bind "c" {
                  LaunchOrFocusPlugin "configuration" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "Normal"
              }
              bind "p" { SwitchToMode "Pane"; }
              bind "r" { SwitchToMode "RenamePane"; }
              bind "t" { SwitchToMode "Tab"; }
              bind "q" { Quit; }
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Ctrl c" { SwitchToMode "Normal"; }
          }
          
          scroll {
              bind "s" { SwitchToMode "Normal"; }
              bind "Ctrl u" { HalfPageScrollUp; }
              bind "Ctrl d" { HalfPageScrollDown; }
              bind "Ctrl b" { PageScrollUp; }
              bind "Ctrl f" { PageScrollDown; }
              bind "u" { HalfPageScrollUp; }
              bind "d" { HalfPageScrollDown; }
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
    
    xdg.configFile."zellij/layouts/default.kdl".text = /* kdl */ ''
      layout {
          default_tab_template {
              children
              pane size=1 borderless=true {
                  plugin location="file:${zjstatus.packages.${pkgs.system}.default}/bin/zjstatus.wasm" {

                      format_left  "#[fg=#${stripHash colors.fg2},bold,bg=#${stripHash colors.bg0_h}] {mode} #[bg=#${stripHash colors.bg0}]    #[bg=#${stripHash colors.bg1},fg=#${stripHash colors.fg1},bold] {session} "
                      format_center "#[fg=#${stripHash colors.fg3},bg=#${stripHash colors.bg0}]{tabs}"
                      format_right "#[fg=#${stripHash colors.fg3},bg=#${stripHash colors.bg0}] {notifications} #[fg=#${stripHash colors.fg2},bg=#${stripHash colors.bg0}] {swap_layout}"
                      format_space "#[bg=#${stripHash colors.bg0}]"
                      format_hide_on_overlength true
                      format_precedence "crl"
              
                      notification_format_unread           "#[fg=#${stripHash colors.yellow},bold]●"
                      notification_format_no_notifications "#[fg=#${stripHash colors.bg3}]○"
                      
                      tab_normal               "#[fg=#${stripHash colors.bg4}] {name} "
                      tab_normal_fullscreen    "#[fg=#${stripHash colors.bg4}] {name}[] "
                      tab_normal_sync          "#[fg=#${stripHash colors.bg4}] {name}<> "
                      tab_active               "#[fg=#${stripHash colors.fg1},bold] {name} "
                      tab_active_fullscreen    "#[fg=#${stripHash colors.fg1},bold] {name}[] "
                      tab_active_sync          "#[fg=#${stripHash colors.fg1},bold] {name}<> "
                      
                      tab_bell                 "#[fg=#${stripHash colors.bright_red},bold]!{name} "
                      tab_bell_fullscreen      "#[fg=#${stripHash colors.bright_red},bold]!{name}[] "
                      tab_bell_sync            "#[fg=#${stripHash colors.bright_red},bold]!{name}<> "
              
                      // @TODO: switch to {name}
                      mode_normal        "#[fg=#${stripHash colors.fg2},bold] NORMAL"
                      mode_locked        "#[fg=#${stripHash colors.fg2},bold] LOCKED"
                      mode_resize        "#[fg=#${stripHash colors.fg2},bold] RESIZE"
                      mode_pane          "#[fg=#${stripHash colors.fg2},bold] PANE"
                      mode_tab           "#[fg=#${stripHash colors.fg2},bold] TAB"
                      mode_scroll        "#[fg=#${stripHash colors.fg2},bold] SCROLL"
                      mode_enter_search  "#[fg=#${stripHash colors.fg2},bold] SEARCH"
                      mode_search        "#[fg=#${stripHash colors.fg2},bold] SEARCH"
                      mode_rename_tab    "#[fg=#${stripHash colors.fg2},bold] RENAME"
                      mode_rename_pane   "#[fg=#${stripHash colors.fg2},bold] RENAME"
                      mode_session       "#[fg=#${stripHash colors.fg2},bold] SESSION"
                      mode_move          "#[fg=#${stripHash colors.fg2},bold] MOVE"
                      mode_prompt        "#[fg=#${stripHash colors.fg2},bold] PROMPT"
                      mode_tmux          "#[fg=#${stripHash colors.fg2},bold] TMUX"
              
                      // datetime
                      // datetime        "#[fg=${stripHash colors.fg4},bold] {format} "
                      // datetime_format "%A, %d %b %Y %H:%M"
                      // datetime_timezone "America/New_York"
                  }
              }
          }
          
          swap_tiled_layout name="vertical" {
              tab max_panes=5 {
                  pane split_direction="vertical" {
                      pane
                      pane { children; }
                  }
              }
              tab max_panes=8 {
                  pane split_direction="vertical" {
                      pane { children; }
                      pane { pane; pane; pane; pane; }
                  }
              }
              tab max_panes=12 {
                  pane split_direction="vertical" {
                      pane { children; }
                      pane { pane; pane; pane; pane; }
                      pane { pane; pane; pane; pane; }
                  }
              }
          }
          
          swap_tiled_layout name="horizontal" {
              tab max_panes=4 {
                  pane
                  pane
              }
              tab max_panes=8 {
                  pane {
                      pane split_direction="vertical" { children; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                  }
              }
              tab max_panes=12 {
                  pane {
                      pane split_direction="vertical" { children; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                  }
              }
          }
          
          swap_tiled_layout name="stacked" {
              tab min_panes=3 {
                  pane split_direction="vertical" {
                      pane
                      pane stacked=true { children; }
                  }
              }
          }
      }
    '';
  }];
}
