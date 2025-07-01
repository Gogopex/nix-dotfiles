{ config, lib, ... }: let
  inherit (lib) enabled merge;
in merge {
  home-manager.sharedModules = [{
    programs.vscode = enabled {
      userSettings = config.editorSettings // {
        # VS Code specific settings
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "window.zoomLevel" = 0.8;
        "editor.fontSize" = 15;
        "git.enableSmartCommit" = true;
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "breadcrumbs.enabled" = true;
        "search.useIgnoreFiles" = false;
        "explorer.confirmDelete" = false;
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.wrapTabs" = true;
        "security.promptForLocalFileProtocolHandling" = false;
        "terminal.integrated.env.osx" = {
          "NO_ZELLIJ" = "1";
        };
      };
    };
  }];
}
