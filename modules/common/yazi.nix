{ lib, ... }:
let
  inherit (lib) enabled merge;
in
merge {
  home-manager.sharedModules = [
    {
      programs.yazi = enabled {
        enableFishIntegration = true;

        settings = {
          log = {
            enabled = false;
          };
          mgr = {
            show_hidden = true;
            sort_by = "mtime";
          };
        };

        keymap = {
          normal = {
            "." = "shell 'printf \"%s\" \"$0\" | pbcopy' --confirm";
            "ctrl-c" = "quit";
            "C-Space" = "toggle_preview";
          };
        };
      };
    }
  ];
}
