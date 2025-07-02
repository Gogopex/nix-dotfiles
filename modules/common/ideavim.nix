{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    home.file.".ideavimrc".source = ../../cfg/ideavimrc;
  }];
}