{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.editors = {
    helix.enable = mkEnableOption "Enable Helix editor config" // { default = true; };
    neovim.enable = mkEnableOption "Enable Neovim (Nixvim) config" // { default = false; };
    vscode.enable = mkEnableOption "Enable VS Code config" // { default = false; };
    cursor.enable = mkEnableOption "Enable Cursor config" // { default = false; };
    ideavim.enable = mkEnableOption "Enable IdeaVim config" // { default = false; };
  };
}
