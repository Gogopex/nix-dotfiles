{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mapAttrs' nameValuePair;
in
{
  home-manager.sharedModules = [
    {
      programs.aerospace = mkIf pkgs.stdenv.isDarwin {
        enable = true;
        launchd.enable = true;

        userSettings = {
          start-at-login = true;

          # Prevent ribbon/accordion layouts
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";

          # Keep normalizations for proper tiling
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

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

          workspace-to-monitor-force-assignment = {
            "1" = "main";
            "2" = "main";
          };

          # Main mode - Single entry point
          mode.main.binding = {
            "alt-w" = "mode window"; # All window operations
          };

          # Window mode - All operations in one place
          mode.window.binding = {
            # Focus navigation (switch between windows)
            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";

            # Move windows (with Shift)
            "shift-h" = "move left";
            "shift-j" = "move down";
            "shift-k" = "move up";
            "shift-l" = "move right";

            # Basic tiling
            m = "layout tiles"; # Maximize/fill

            # Window resizing
            i = "resize smart +50";
            o = "resize smart -50";

            # Workspace navigation
            "1" = "workspace 1";
            "2" = "workspace 2";
            "shift-1" = "move-node-to-workspace 1";
            "shift-2" = "move-node-to-workspace 2";

            # Utility
            f = "layout floating tiling";
            c = "close";

            # Exit mode
            esc = "mode main";
            enter = "mode main";
            "alt-w" = "mode main"; # Toggle back
          };
        };
      };
    }
  ];
}
