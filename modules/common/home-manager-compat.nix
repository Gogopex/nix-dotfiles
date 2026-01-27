{ lib, pkgs, ... }:
{
  options = {
    home-manager.sharedModules = lib.mkOption {
      type = lib.types.listOf lib.types.raw;
      default = [ ];
      description = "Compatibility placeholder for home-manager sharedModules";
    };

    nixpkgs.hostPlatform.system = lib.mkOption {
      type = lib.types.str;
      default = pkgs.stdenv.hostPlatform.system;
      readOnly = true;
      description = "System platform string";
    };
  };

  config = {
    home-manager.sharedModules = [ ];
  };
}
