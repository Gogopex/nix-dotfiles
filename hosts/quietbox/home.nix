# Home-manager configuration for quietbox (Arch Linux)
{ config, pkgs, lib, inputs, ... }:

{
  home = {
    username = "ludwig";
    homeDirectory = "/home/ludwig";
    stateVersion = "24.11";
  };
  
  # Let home-manager manage itself
  programs.home-manager.enable = true;
  
  # Shell configuration
  userShell = "fish";
  
  # System info for modules that need it  
  system.primaryUser = "ludwig";
  
  # Type for conditional module loading
  type = "server";
  
  # Set helix as default editor for headless server
  programs.helix.defaultEditor = true;
}