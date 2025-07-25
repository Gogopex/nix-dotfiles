lib:
lib.darwinSystem' (
  { lib, pkgs, config, ... }:
  let
    inherit (lib) collectNix remove;
  in
  {
    imports = collectNix ./. |> remove ./default.nix;

    type = "desktop";

    networking.hostName = "macbook";
    system.primaryUser = "ludwig";

    # Set userShell to "fish" or "nushell" to switch shells
    userShell = "fish";

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
