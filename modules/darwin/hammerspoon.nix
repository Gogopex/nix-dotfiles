{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    home.file.".hammerspoon/init.lua".source = ../../cfg/hammerspoon/init.lua;
  }];
}