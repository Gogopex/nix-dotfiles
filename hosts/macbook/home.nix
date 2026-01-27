{ config, lib, inputs, pkgs, ... }:
let
  libWithExtensions = lib // (import ../../lib inputs lib lib);

  modulePaths =
    (lib.collectNix ../../modules/common)
    ++ (lib.collectNix ../../modules/darwin);

  filteredModulePaths = lib.filter (
    path: builtins.baseNameOf path != "home-manager.nix"
  ) modulePaths;

  hmEval = libWithExtensions.evalModules {
    modules =
      filteredModulePaths
      ++ [
        {
          config._module.check = false;
        }
      ];
    specialArgs = {
      inherit inputs pkgs;
      nixvim = inputs.nixvim;
    };
  };

  sharedModules = hmEval.config.home-manager.sharedModules or [];
in
{
  imports =
    [
      ../../modules/common/system.nix
      ../../modules/common/user.nix
      ../../modules/common/theme.nix
      ../../modules/common/editors.nix
      ../../modules/common/editor-settings.nix
      ../../modules/common/nix-config.nix
      ../../modules/common/shell-config.nix
    ]
    ++ sharedModules;

  nixConfig.manage = false;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
