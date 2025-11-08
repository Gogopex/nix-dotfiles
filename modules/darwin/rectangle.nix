{ lib, pkgs, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  hmLib = inputs.home-manager.lib;
  cfg = config.darwin.windowManagers.rectangle.enable;
  rectanglePlist = ../../cfg/rectangle.plist;
in
{
  options.darwin.windowManagers.rectangle.enable =
    mkEnableOption "Configure Rectangle window manager" // {
      default = false;
    };

  config = mkIf (cfg && pkgs.stdenv.isDarwin) {
    home-manager.sharedModules = [
      {
        home.packages = [ pkgs.rectangle ];

        home.activation.rectanglePreferences =
          hmLib.hm.dag.entryAfter ["writeBoundary"] ''
            if command -v defaults >/dev/null 2>&1; then
              defaults import com.knollsoft.Rectangle ${rectanglePlist} >/dev/null 2>&1 || true
              /usr/bin/killall -u "$USER" cfprefsd >/dev/null 2>&1 || true
            fi
          '';
      }
    ];
  };
}
