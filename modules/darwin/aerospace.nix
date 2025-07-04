{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mapAttrs' nameValuePair;
in {
  home-manager.sharedModules = [{
    programs.aerospace = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      launchd.enable = true;  # Use built-in launchd support
      
      userSettings = {
        start-at-login = true;
        
        # Gaps configuration
        gaps = {
          inner.horizontal = 10;
          inner.vertical = 10;
          outer = {
            left = 10;
            bottom = 10;
            top = 10;
            right = 10;
          };
        };
        
        # Workspace configurations
        workspace = {
          "1" = { layout = "tiles"; };
          "2" = { layout = "tiles"; };
          "3" = { layout = "tiles"; };
          "4" = { layout = "tiles"; };
        };
        
        # Main mode keybindings
        mode.main.binding = lib.mkMerge [
          # Single keys
          {
            "alt-f" = "no-op";
          }
          
          # Window focus navigation (cmd-alt + hjkl)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-${key}" action) {
            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";
          })
          
          # Window movement (cmd-alt-shift + hjkl)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            h = "move left";
            j = "move down";
            k = "move up";
            l = "move right";
          })
          
          # Window resizing (cmd-alt-shift + ui)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            u = "resize smart -50";
            i = "resize smart +50";
          })
          
          # Window joining (cmd-alt-shift + yo)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            y = "join-with right";
            o = "join-with down";
          })
          
          # Layout and focus management (cmd-alt-shift + nmp)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            n = "layout floating tiling";
            m = "layout tiles";
            p = "focus-back-and-forth";
          })
        ];
      };
    };
  }];
}