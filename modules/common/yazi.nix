{ lib, ... }:
let
  inherit (lib) enabled merge;
  copyToClipboardShell =
    "copy_to_clipboard() { if command -v pbcopy >/dev/null 2>&1; then pbcopy; elif command -v wl-copy >/dev/null 2>&1; then wl-copy; elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard; elif command -v xsel >/dev/null 2>&1; then xsel --clipboard --input; else exit 127; fi; }";
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
            "." = "shell '${copyToClipboardShell}; printf \"%s\" \"$0\" | copy_to_clipboard' --confirm";
            "ctrl-c" = "quit";
            "C-Space" = "toggle_preview";
          };
        };
      };
    }
  ];
}
