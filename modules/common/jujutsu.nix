{ config, lib, ... }:
let
  inherit (lib) enabled merge;
in
merge {
  home-manager.sharedModules = [
    {
      programs.jujutsu = enabled {
        settings = {
          user.name = config.user.name;
          user.email = config.user.email;

          ui.default-command = "log";
          ui.diff-editor = ":builtin";
          ui.graph.style = if config.theme.cornerRadius > 0 then "curved" else "square";

          aliases = {
            ".." = [
              "edit"
              "@-"
            ];
            ",," = [
              "edit"
              "@+"
            ];
          };

          git.auto-local-bookmark = true;
        };
      };
    }
  ];
}
