{
  config,
  lib,
  pkgs,
  ...
}:

{
  home-manager.sharedModules = [
    {
      home.file.".hammerspoon" = {
        source = ../../cfg/hammerspoon;
        recursive = true;
      };
    }
  ];
}
