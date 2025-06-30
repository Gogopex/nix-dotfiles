{ config, lib, ... }: let
  inherit (lib) last mkConst mkOption mkValue splitString types;
in {
  options = {
    os = mkConst <| last <| splitString "-" config.nixpkgs.hostPlatform.system;

    isLinux  = mkConst <| config.os == "linux";
    isDarwin = mkConst <| config.os == "darwin";

    type = mkValue "desktop"; # Default to desktop for now

    isDesktop = mkConst <| config.type == "desktop";
    isServer  = mkConst <| config.type == "server";
  };
  
  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}