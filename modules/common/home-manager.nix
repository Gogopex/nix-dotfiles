{ config, lib, inputs, ... }: let
  inherit (lib) mkIf;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    
    extraSpecialArgs = {
      inherit inputs;
      inherit (inputs) ghosttySrc zjstatus;
    };
    
    sharedModules = [{
      imports = [ ./theme.nix ];
      home.username = config.system.primaryUser or "ludwig";
      programs.home-manager.enable = true;
    }];
  };
}
