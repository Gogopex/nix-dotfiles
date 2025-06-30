lib: lib.darwinSystem' ({ lib, ... }: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  type = "desktop";

  networking.hostName = "macbook";
  system.primaryUser = "ludwig";

  users.users.ludwig = {
    name = "ludwig";
    home = "/Users/ludwig";
  };

  home-manager.users.ludwig.home = {
    stateVersion  = "24.05";
    homeDirectory = "/Users/ludwig";
  };

  system.stateVersion = 6;
})