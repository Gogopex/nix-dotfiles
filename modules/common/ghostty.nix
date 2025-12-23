{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    enabled
    mapAttrsToList
    merge
    mkIf
    ;
in
merge
<| mkIf config.isDesktop {
  home-manager.sharedModules = [
    {
      programs.ghostty = enabled {
        package = mkIf config.isDarwin null;

        settings = with config.theme; {
          theme = "Gruvbox Dark";

          font-family = font.mono.name;
          font-family-bold = "${font.mono.name} Bold";
          font-family-italic = "${font.mono.name} Italic";
          font-family-bold-italic = "${font.mono.name} Bold Italic";
          window-title-font-family = font.mono.name;
          font-size = font.size.normal;

          window-padding-x = padding;
          window-padding-y = padding;
          window-decoration = "none";
          window-save-state = "always";

          shell-integration = config.userShell;
          confirm-close-surface = false;
          quit-after-last-window-closed = true;
          mouse-hide-while-typing = true;
          auto-update = "off";

          scrollback-limit = 0;

          macos-titlebar-style = mkIf config.isDarwin "hidden";

          keybind = [
            "global:shift+alt+t=toggle_quick_terminal"
          ]
          ++ (mapAttrsToList (name: value: "ctrl+${name}=${value}") {
            space = "toggle_fullscreen";
            h = "unbind";
            j = "unbind";
            k = "unbind";
            l = "unbind";
          })
          ++ (mapAttrsToList (name: value: "ctrl+shift+${name}=${value}") {
            c = "copy_to_clipboard";
            v = "paste_from_clipboard";

            enter = "reset_font_size";
            plus = "increase_font_size:1";
            minus = "decrease_font_size:1";
          })
          ++ (mapAttrsToList (name: value: "super+${name}=${value}") {
            h = "unbind";
            l = "unbind";
            t = "unbind";
            w = "unbind";
            d = "unbind";
          })
          ++ (mapAttrsToList (name: value: "super+shift+${name}=${value}") {
            t = "new_tab";
            d = "unbind";
            w = "unbind";
          })
          ++ (mapAttrsToList (name: value: "super+ctrl+${name}=${value}") {
            h = "unbind";
            j = "unbind";
            k = "unbind";
            l = "unbind";
          })
          ++ (mapAttrsToList (name: value: "super+ctrl+shift+${name}=${value}") {
            h = "unbind";
            l = "unbind";
          });
        };
      };
    }
  ];
}
