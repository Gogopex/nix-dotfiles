{ config, lib, inputs, pkgs, ... }:
let
  libWithExtensions = lib // (import ../../lib inputs lib lib);

  modulePaths =
    (lib.collectNix ../../modules/common)
    ++ (lib.collectNix ../../modules/darwin);

  filteredModulePaths = lib.filter (
    path: builtins.baseNameOf path != "home-manager.nix"
  ) modulePaths;

  extractModules = module:
    if module ? home-manager.sharedModules then
      module.home-manager.sharedModules
    else
      [];

  importedModules = map (
    path: import path { inherit config pkgs inputs; lib = libWithExtensions; }
  ) filteredModulePaths;

  sharedModules = lib.flatten (map extractModules importedModules);
in
{
  imports =
    [
      ../../modules/common/system.nix
      ../../modules/common/user.nix
      ../../modules/common/theme.nix
      ../../modules/common/editors.nix
      ../../modules/common/editor-settings.nix
      ../../modules/common/shell-config.nix
    ]
    ++ sharedModules;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
