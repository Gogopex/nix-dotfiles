{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
in
{
  options.nixConfig.manage = mkOption {
    type = types.bool;
    default = true;
    description = "Whether Home Manager should manage ~/.config/nix/nix.conf.";
  };

  config = mkIf config.nixConfig.manage {
    home-manager.sharedModules = [
      {
        xdg.configFile."nix/nix.conf".text = ''
          accept-flake-config = true
          eval-cache = true
          max-jobs = 6
          cores = 4
        '';
      }
    ];
  };
}
