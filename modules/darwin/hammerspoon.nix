{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.darwin.hammerspoon.enable;
in
{
  options.darwin.hammerspoon.enable = mkEnableOption "Configure Hammerspoon automation tool";

  config = mkIf (cfg && pkgs.stdenv.isDarwin) {
    homebrew.casks = [ "hammerspoon" ];

    home-manager.sharedModules = [
      {
        home.file.".hammerspoon" = {
          source = ../../cfg/hammerspoon;
          recursive = true;
        };
      }
    ];
  };
}
