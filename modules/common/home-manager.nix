{ config, lib, inputs, ... }: let
  inherit (lib) mkIf;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    
    # Pass special args to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
      inherit (inputs) ghosttySrc zjstatus;
    };
    
    # Shared modules for all users
    sharedModules = [{
      # Import the theme so HM modules can access it
      imports = [ ./theme.nix ];
      
      # Basic home configuration
      home.username = config.system.primaryUser or "ludwig";
      
      # Common programs available to all users
      programs.home-manager.enable = true;
    }];
  };
}