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
  
  # Collect common modules
  commonModules = collectNix ../../modules/common;
  
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
  class = "nixos";  # Marks this as a Linux system (vs Darwin)
  config = homeConfig;
}