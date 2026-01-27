{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config =
    { documentation.enable = false; }
    // mkIf config.nix.enable {
      nix = {
        channel.enable = false;

        gc = {
          automatic = true;
          interval = {
            Weekday = 0;
            Hour = 3;
            Minute = 0;
          };
          options = "--delete-older-than 30d";
        };

        optimise.automatic = true;
      };
    };
}
