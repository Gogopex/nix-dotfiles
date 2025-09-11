# Compatibility module for standalone home-manager
# This module provides compatibility shims for NixOS/Darwin options
{ config, lib, pkgs, ... }:
{
  options = {
    # Compatibility for home-manager.sharedModules
    home-manager = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Compatibility placeholder for home-manager options";
    };
    
    # Provide nixpkgs.hostPlatform for common modules
    nixpkgs.hostPlatform.system = lib.mkOption {
      type = lib.types.str;
      default = pkgs.stdenv.hostPlatform.system;
      readOnly = true;
      description = "System platform string";
    };
  };
  
  config = {
    # This is a no-op in standalone mode
    home-manager = {};
  };
}