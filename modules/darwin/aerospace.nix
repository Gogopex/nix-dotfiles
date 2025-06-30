{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf;
in {
  home-manager.sharedModules = [{
    programs.aerospace = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../../cfg/aerospace/aerospace.toml);
    };
  }];
}