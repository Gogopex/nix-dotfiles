{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  home-manager.sharedModules = [
    {
      programs.aerospace = mkIf pkgs.stdenv.isDarwin {
        enable = true;
        launchd.enable = true;

        userSettings = {
          start-at-login = true;

          after-startup-command = [
            "exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0"
          ];

          accordion-padding = 5;

          # default-root-container-layout = "tiles";
          # default-root-container-orientation = "auto";

          # enable-normalization-flatten-containers = true;
          # enable-normalization-opposite-orientation-for-nested-containers = true;

          gaps = {
            inner.horizontal = 0;
            inner.vertical = 0;
            outer = {
              left = 0;
              bottom = 0;
              top = 0;
              right = 0;
            };
          };

          # workspace-to-monitor-force-assignment = {
          #   "1" = "main";
          #   "2" = "main";
          # };

          mode.main.binding = {
            "alt-w" = "mode window"; 
          };

          mode.window.binding = {
            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";

            f = "fullscreen";
            "shift-r" = "flatten-workspace-tree";

            "shift-h" = "move left";
            "shift-j" = "move down";
            "shift-k" = "move up";
            "shift-l" = "move right";

            "slash" = "layout tiles horizontal vertical";
            "comma" = "layout accordion horizontal vertical"; 

            i = "resize smart +50";
            o = "resize smart -50";

            "1" = "workspace 1";
            "2" = "workspace 2";
            "shift-1" = "move-node-to-workspace 1";
            "shift-2" = "move-node-to-workspace 2";

            c = "close";

            esc = "mode main";
            enter = "mode main";
            "alt-w" = "mode main"; 
          };
        };
      };
    }
  ];
}
