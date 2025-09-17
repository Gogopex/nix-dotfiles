{ config, pkgs, lib, inputs, ... }:
let
  libWithExtensions = lib // (import ../../lib inputs lib lib);
  
  helixModule = import ./helix.nix { lib = libWithExtensions; };
  gitModule = import ./git.nix { lib = libWithExtensions; };
  jujutsuModule = import ./jujutsu.nix { inherit config; lib = libWithExtensions; };
  packagesModule = import ./packages.nix { inherit config; lib = libWithExtensions; };
  tmuxModule = import ./tmux.nix { inherit config; lib = libWithExtensions; };
  yaziModule = import ./yazi.nix { lib = libWithExtensions; };
  brootModule = import ./broot.nix { inherit config; lib = libWithExtensions; };
  
  extractModules = module:
    if module ? home-manager.sharedModules then
      module.home-manager.sharedModules
    else
      [];
in
{
  imports = lib.flatten [
    (extractModules helixModule)
    (extractModules gitModule)
    (extractModules jujutsuModule)
    (extractModules packagesModule)
    (extractModules tmuxModule)
    (extractModules yaziModule)
    (extractModules brootModule)
  ];
}