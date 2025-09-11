lib:
let
  inherit (lib)
    inputs
    collectNix
    remove
    ;
  
  system = "x86_64-linux";
  
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  
  # Collect common modules (but filter out Darwin-specific ones)
  commonModules = collectNix ../../modules/common 
    |> remove ../../modules/common/home-manager.nix;  # This is for Darwin/NixOS systems
  
  # Collect local modules for this host
  localModules = collectNix ./. |> remove ./default.nix;
  
  homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    
    extraSpecialArgs = {
      inherit inputs lib;
      zjstatus = inputs.zjstatus;
    };
    
    modules = commonModules ++ localModules;
  };
in
{
  # This marks it as a Linux system for the flake logic
  class = "nixos";
  config = homeConfig;
}