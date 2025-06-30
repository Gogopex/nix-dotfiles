{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) enabled merge mkIf;
  zjstatus = inputs.zjstatus or null;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    programs.zellij = enabled {
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
      plugins {
          zjstatus location="file:${zjstatus.packages.${pkgs.system}.default}/bin/zjstatus.wasm" {
              // format for notifications and status
              format_left  "#[fg=#689d6a,bold]#[bg=#3c3836] {mode}#[bg=#689d6a,fg=#1d2021,bold] {session} "
              format_center "#[fg=#ddc7a1,bg=#3c3836]{tabs}"
              format_right "#[fg=#ddc7a1,bg=#3c3836] {notifications}#[fg=#689d6a,bg=#3c3836] {datetime}"
              format_space "#[bg=#1d2021]"
              format_hide_on_overlength true
              format_precedence "crl"
      
              // notification settings for Claude Code sessions and commands
              notification_format_unread           "#[fg=#d79921,bold]●"
              notification_format_no_notifications "#[fg=#504945]○"
              
              // tab formatting with bell alerts
              tab_normal               "#[fg=#6C7086] {name} "
              tab_normal_fullscreen    "#[fg=#6C7086] {name}[] "
              tab_normal_sync          "#[fg=#6C7086] {name}<> "
              tab_active               "#[fg=#9ECE6A,bold] {name} "
              tab_active_fullscreen    "#[fg=#9ECE6A,bold] {name}[] "
              tab_active_sync          "#[fg=#9ECE6A,bold] {name}<> "
              
              tab_bell                 "#[fg=#F7768E,bold]!{name} "
              tab_bell_fullscreen      "#[fg=#F7768E,bold]!{name}[] "
              tab_bell_sync            "#[fg=#F7768E,bold]!{name}<> "
      
              // mode indicators
              mode_normal        "#[fg=#689d6a,bold] NORMAL"
              mode_locked        "#[fg=#d79921,bold] LOCKED"
              mode_resize        "#[fg=#d3869b,bold] RESIZE"
              mode_pane          "#[fg=#458588,bold] PANE"
              mode_tab           "#[fg=#b16286,bold] TAB"
              mode_scroll        "#[fg=#689d6a,bold] SCROLL"
              mode_enter_search  "#[fg=#d79921,bold] SEARCH"
              mode_search        "#[fg=#d79921,bold] SEARCH"
              mode_rename_tab    "#[fg=#b16286,bold] RENAME"
              mode_rename_pane   "#[fg=#458588,bold] RENAME"
              mode_session       "#[fg=#d3869b,bold] SESSION"
              mode_move          "#[fg=#d79921,bold] MOVE"
              mode_prompt        "#[fg=#689d6a,bold] PROMPT"
              mode_tmux          "#[fg=#98971a,bold] TMUX"
      
              // datetime
              datetime        "#[fg=#6C7086,bold] {format} "
              datetime_format "%A, %d %b %Y %H:%M"
              datetime_timezone "America/New_York"
          }
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
  }];
}