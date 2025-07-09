{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mapAttrs' nameValuePair;
in {
  home-manager.sharedModules = [{
    programs.aerospace = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      launchd.enable = true;  
      
      userSettings = {
        start-at-login = true;
        
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
        
        workspace = {
          "1" = { layout = "tiles"; };
          "2" = { layout = "tiles"; };
          "3" = { layout = "tiles"; };
          "4" = { layout = "tiles"; };
        };
        
        mode.main.binding = lib.mkMerge [
          {
            "alt-f" = "no-op";
          }
          
          # window focus navigation (cmd-alt + hjkl)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-${key}" action) {
            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";
          })
          
          # window movement (cmd-alt-shift + hjkl)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            h = "move left";
            j = "move down";
            k = "move up";
            l = "move right";
          })
          
          # window resizing (cmd-alt-shift + ui)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            u = "resize smart -50";
            i = "resize smart +50";
          })
          
          # window joining (cmd-alt-shift + yo)
          (mapAttrs' (key: action: nameValuePair "cmd-alt-shift-${key}" action) {
            y = "join-with right";
            o = "join-with down";
          })
          
          # layout and focus management (cmd-alt-shift + nmp)
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
