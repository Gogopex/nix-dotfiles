{ lib, pkgs, ... }:
{
  options = {
    home-manager = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Compatibility placeholder for home-manager options";
    };
    
    nixpkgs.hostPlatform.system = lib.mkOption {
      type = lib.types.str;
      default = pkgs.stdenv.hostPlatform.system;
      readOnly = true;
      description = "System platform string";
    };
  };
  
  config = {
    home-manager = {};
  };
}
