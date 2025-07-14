{ config, lib, ... }:
let
  inherit (lib) merge;

  cursorSettings = config.editorSettings // {
    "workbench.colorTheme" = "Gruvbox Dark Soft";
    "editor.fontSize" = 18;
    "terminal.integrated.fontSize" = 18;
    "chat.editor.fontSize" = 16;
    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };
    "cursor.composer.collapsePaneInputBoxPills" = true;
    "cursor.composer.renderPillsInsteadOfBlocks" = true;
    "git.confirmSync" = false;
    "cursor.composer.cmdPFilePicker2" = true;
    "cursor.terminal.usePreviewBox" = true;
    "go.toolsManagement.autoUpdate" = true;
    "remote.SSH.path" = "/opt/homebrew/bin/ssh";
    "remote.SSH.remotePlatform" = {
      "bigdave" = "linux";
    };
    "remote.SSH.enableDynamicForwarding" = false;
    "remote.SSH.enableAgentForwarding" = false;
    "gitlens.home.preview.enabled" = false;
    "update.releaseTrack" = "prerelease";
    "cursor.composer.textSizeScale" = 1.15;
    "cursor.composer.shouldAllowCustomModes" = true;
    "cursor.cpp.enablePartialAccepts" = true;
    "clangd.detectExtensionConflicts" = false;
    "cursor.composer.shouldChimeAfterChatFinishes" = true;
    "lldb.suppressUpdateNotifications" = true;
    "lean4.alwaysAskBeforeInstallingLeanVersions" = false;
    "terminal.integrated.shell.osx" = "/run/current-system/sw/bin/fish";
    "terminal.integrated.automationShell.osx" = "/run/current-system/sw/bin/fish";
  };
in
merge {
  home-manager.sharedModules = [
    {
      home.file."Library/Application Support/Cursor/User/settings.json".text =
        builtins.toJSON cursorSettings;
    }
  ];
}
