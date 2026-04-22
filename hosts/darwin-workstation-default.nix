{
  lib,
  hostName,
  hostModules,
}:
lib.darwinSystem' (
  {
    pkgs,
    config,
    ...
  }:
  {
    imports = hostModules;

    type = "desktop";

    networking.hostName = hostName;
    system.primaryUser = "ludwig";

    nixConfig.manage = false;

    userShell = "fish";

    darwin.windowManagers = {
      rectangle.enable = true;
    };

    darwin.hammerspoon.enable = true;

    users.users.ludwig = {
      name = "ludwig";
      home = "/Users/ludwig";
      shell = if config.userShell == "nushell" then pkgs.nushell else pkgs.fish;
    };

    home-manager.users.ludwig.home = {
      stateVersion = "24.05";
      homeDirectory = "/Users/ludwig";
    };

    system.stateVersion = 6;
  }
)
