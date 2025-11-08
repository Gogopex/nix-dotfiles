{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.darwin.windowManagers.aerospace.enable;
in
{
  options.darwin.windowManagers.aerospace.enable =
    mkEnableOption "Configure the Aerospace tiling window manager"
    // {
      default = true;
    };

  config = mkIf (cfg && pkgs.stdenv.isDarwin) {
    home-manager.sharedModules = [
      {
        home.packages = [ pkgs.aerospace ];

        programs.aerospace = {
          enable = true;
          launchd.enable = true;

          userSettings = {
            start-at-login = true;

            after-startup-command = [
              ''
                exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0
              ''
              ''
                while [ "$(aerospace list-windows --workspace focused | wc -l)" -lt 2 ]; do sleep 0.2; done

                aerospace layout h_tiles
                aerospace focus right
                aerospace join-with left
                aerospace layout v_accordion
                aerospace focus up
                aerospace move left
                aerospace focus left
                aerospace layout h_tiles
                aerospace resize smart 0.6
                aerospace focus right
                aerospace layout v_accordion
              ''
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

              "alt-h" = [ ];
              "alt-j" = [ ];
              "alt-k" = [ ];
              "alt-l" = [ ];

              "alt-shift-h" = [ ];
              "alt-shift-j" = [ ];
              "alt-shift-k" = [ ];
              "alt-shift-l" = [ ];

              "alt-1" = [ ];
              "alt-2" = [ ];
              "alt-3" = [ ];
              "alt-4" = [ ];
              "alt-5" = [ ];
              "alt-6" = [ ];
              "alt-7" = [ ];
              "alt-8" = [ ];
              "alt-9" = [ ];

              "alt-shift-1" = [ ];
              "alt-shift-2" = [ ];
              "alt-shift-3" = [ ];
              "alt-shift-4" = [ ];
              "alt-shift-5" = [ ];
              "alt-shift-6" = [ ];
              "alt-shift-7" = [ ];
              "alt-shift-8" = [ ];
              "alt-shift-9" = [ ];
            };

            mode.window.binding = {
              e = [
                "join-with up"
                "layout v_accordion"
              ];
              t = "layout tiles";
              r = [
                "join-with left"
                "layout tiles horizontal"
              ];
              s = [
                "join-with right"
                "layout v_accordion"
              ];

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

              "shift-b" = "balance-sizes";
              "shift-f" = "layout floating tiling";
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
  };
}
