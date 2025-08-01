{ lib, ... }:
let
  inherit (lib) mkValue mapAttrsToList;
in
{
  options.editorSettings = mkValue {
    "editor.fontFamily" = "Berkeley Mono";
    "editor.fontSize" = 18;
    "editor.lineNumbers" = "on";
    "editor.wordWrap" = "off";
    "editor.insertSpaces" = false;
    "editor.tabSize" = 8;
    "editor.cursorStyle" = "line";
    "editor.inlineSuggest.enabled" = true;
    "editor.formatOnPaste" = true;
    "editor.fontLigatures" = true;
    "terminal.integrated.fontFamily" = "'Berkeley Mono', monospace";
    "terminal.integrated.fontSize" = 16;

    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        "before" = [
          "g"
          "h"
        ];
        "after" = [ "^" ];
      }
      {
        "before" = [
          "g"
          "l"
        ];
        "after" = [ "$" ];
      }
      {
        "before" = [
          "<space>"
          "y"
        ];
        "commands" = [ "editor.action.clipboardCopyAction" ];
      }
      {
        "before" = [
          "<space>"
          "d"
        ];
        "after" = [
          "\""
          "_"
          "d"
        ];
      }
    ];

    "diffEditor.ignoreTrimWhitespace" = false;
    "[javascript]" = {
      "editor.defaultFormatter" = "vscode.typescript-language-features";
    };
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "twig-language-2.bracePadding" = true;
    "twig-language-2.spaceClose" = true;
    "liveshare.presence" = true;
    "intelephense.environment.phpVersion" = "7.4.13";
    "php.suggest.basic" = false;
    "[php]" = {
      "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
      "editor.formatOnSave" = true;
    };
    "emmet.includeLanguages" = {
      "twig" = "html";
    };
    "files.exclude" = lib.listToAttrs (
      (map (path: lib.nameValuePair path true) [
        "**/.DS_Store"
        "**/.git"
        "**/.hg"
        "**/.svn"
        "**/app/cache/**"
        "**/CVS"
        "app/cache/**"
        "**/node_modules/**"
        "**/.venv/**"
      ])
      ++ [
        (lib.nameValuePair "**/*.js" { "when" = "$(basename).ts"; })
        (lib.nameValuePair "**/**.js" { "when" = "$(basename).tsx"; })
      ]
    );
    "rust-analyzer.checkOnSave.command" = "clippy";
    "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
    "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";
    "editor.defaultFormatter" = "kokororin.vscode-phpfmt";
    "editor.wordSeparators" = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
    "github.copilot.enable" = {
      "*" = false;
      "plaintext" = true;
      "markdown" = false;
      "scminput" = false;
      "yaml" = false;
      "rust" = true;
      "php" = true;
      "python" = true;
      "uiua" = false;
    };
    "makefile.configureOnOpen" = true;
    "editor.columnSelection" = true;
    "terminal.external.osxExec" = "Ghostty.app";
    "terminal.integrated.fontLigatures.enabled" = true;
    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };
    "jupyter.askForKernelRestart" = false;
    "chat.commandCenter.enabled" = false;
    "remote.SSH.showLoginTerminal" = true;
    "remote.SSH.useExecServer" = true;
    "remote.SSH.remotePlatform" = {
      "38.97.6.9" = "linux";
      "bigdave" = "linux";
    };
    "workbench.startupEditor" = "none";
    "amp.url" = "https://ampcode.com/";

    # Missing configurations from flake.nix
    "emmet.triggerExpansionOnTab" = true;
    "emmet.syntaxProfiles" = {
      "html" = {
        "filters" = "bem";
      };
    };
    "search.exclude" = {
      "**/app/cache" = true;
      "**/app/logs" = true;
      "**/node_modules/**" = true;
      "**/var/cache" = true;
      "**/var/logs" = true;
      "**/web" = true;
      "app/cache/*.xml" = true;
      "app/cache/**" = true;
    };
    "files.watcherExclude" = lib.listToAttrs (
      map (path: lib.nameValuePair path true) [
        "**/app/cache/**"
        "**/var/cache/**"
        "**/var/logs/**"
        "**/node_modules/**"
        "**/.venv/**"
      ]
    );
    "[python]" = {
      "editor.defaultFormatter" = "ms-python.python";
      "editor.formatOnType" = true;
    };
  };
}
