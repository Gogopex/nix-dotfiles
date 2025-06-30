{ config, lib, pkgs, ... }: let
  inherit (lib) enabled mapAttrsToList merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    programs.ghostty = enabled {
      # don't install ghostty package on Darwin (it's installed manually)
      package = mkIf config.isDarwin null;

      settings = with config.theme; {
        # theme settings
        theme = "GruvboxDark";
        
        # font settings from global theme
        font-family              = font.mono.name;
        font-family-bold         = "${font.mono.name} Bold";
        font-family-italic       = "${font.mono.name} Italic";
        font-family-bold-italic  = "${font.mono.name} Bold Italic";
        window-title-font-family = font.mono.name;
        font-size                = font.size.normal;
        
        # Window settings
        window-padding-x = padding;
        window-padding-y = padding;
        window-decoration = "none";
        window-save-state = "always";
        
        # Shell and behavior settings
        shell-integration = "fish";
        confirm-close-surface = false;
        quit-after-last-window-closed = true;
        mouse-hide-while-typing = true;
        auto-update = "off";
        
        # macOS specific settings
        macos-titlebar-style = mkIf config.isDarwin "tabs";
        
        # Keybindings
        keybind = [
          # Quick terminal toggle
          "global:shift+alt+t=toggle_quick_terminal"
          
          # Window management
          "ctrl+space=toggle_fullscreen"
          "super+shift+t=new_tab"
          
          # Unbind keys used by zellij
          "ctrl+h=unbind"
          "ctrl+j=unbind"
          "ctrl+k=unbind"
          "ctrl+l=unbind"
          "super+h=unbind"
          "super+l=unbind"
          "super+t=unbind"
          "super+w=unbind"
          "super+d=unbind"
          "super+shift+d=unbind"
          "super+shift+w=unbind"
          "super+ctrl+h=unbind"
          "super+ctrl+j=unbind"
          "super+ctrl+k=unbind"
          "super+ctrl+l=unbind"
          "super+ctrl+shift+h=unbind"
          "super+ctrl+shift+l=unbind"
        ] ++ (
          # Additional keybindings inspired by NCC's structure
          mapAttrsToList (name: value: "ctrl+shift+${name}=${value}") {
            c = "copy_to_clipboard";
            v = "paste_from_clipboard";
            
            # Font size controls
            enter = "reset_font_size";
            plus  = "increase_font_size:1";
            minus = "decrease_font_size:1";
          }
        );
      };
    };
  }];
}
