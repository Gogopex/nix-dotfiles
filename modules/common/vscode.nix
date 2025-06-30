{ config, lib, ... }: let
  inherit (lib) enabled merge;
in merge {
  home-manager.sharedModules = [{
    programs.vscode = enabled {
      userSettings = config.editorSettings // {
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "git.enableSmartCommit" = true;
      };
    };
  }];
}
