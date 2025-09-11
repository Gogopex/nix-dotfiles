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
  
  # Extend lib with our custom functions for modules to use
  libWithExtensions = inputs.nixpkgs.lib.extend (self: super: 
    import ../../lib inputs self super
  );
  
  # Collect common modules (but filter out Darwin-specific ones)
  commonModules = collectNix ../../modules/common 
    |> remove ../../modules/common/home-manager.nix;  # This is for Darwin/NixOS systems
  
  # Collect local modules for this host
  localModules = collectNix ./. |> remove ./default.nix;
  
  homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    
    extraSpecialArgs = {
      inherit inputs;
      lib = libWithExtensions;  # Pass our extended lib
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