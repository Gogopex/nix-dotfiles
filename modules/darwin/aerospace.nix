{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf;
in {
  home-manager.sharedModules = [{
    programs.aerospace = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      launchd.enable = true;  # Use built-in launchd support
      userSettings = builtins.fromTOML (builtins.readFile ../../cfg/aerospace/aerospace.toml);
    };
  }];
}