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
            "exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0
              while [ $(aerospace list-windows --workspace focused | wc -l) -lt 2 ]; do sleep 0.2; done
              aerospace focus right
              aerospace join-with up
              aerospace layout v_accordion"
          ];

          accordion-padding = 5;

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

          mode.main.binding = {
            "alt-w" = "mode window"; 
          };

          mode.window.binding = {
            e = ["join-with up" "layout v_accordion"];
            t = "layout tiles";
            r = ["join-with left" "layout tiles horizontal"];
            s = ["join-with right" "layout v_accordion"];

            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";

            f = "fullscreen";
            "shift-R" = "flatten-workspace-tree";

            "shift-H" = "move left";
            "shift-J" = "move down";
            "shift-K" = "move up";
            "shift-L" = "move right";

            "shift-B" = "balance-sizes";
            "shift-F" = "layout floating tiling";
            "backslash" = "focus-back-and-forth";

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
