lib:
lib.nixosSystem' (
  { lib, pkgs, config, inputs, ... }:
  let
    inherit (lib) collectNix remove;
  in
  {
    imports = collectNix ./. |> remove ./default.nix;

    class = "nixos";
    type = "server";  # Server type for headless system

    networking.hostName = "quietbox";
    system.primaryUser = "ludwig";

    # Shell configuration
    userShell = "fish";
    
    # NixOS system configuration (minimal for home-manager only)
    system.stateVersion = "24.11";
    nixpkgs.hostPlatform = "x86_64-linux";
    
    # Minimal boot configuration
    boot.loader.grub.enable = false;
    fileSystems."/" = { device = "/dev/null"; };

    # User configuration
    users.users.ludwig = {
      isNormalUser = true;
      home = "/home/ludwig";
      shell = if config.userShell == "nushell" then pkgs.nushell else pkgs.fish;
    };

    # Home-manager configuration
    home-manager.users.ludwig = {
      home = {
        stateVersion = "24.11";
        homeDirectory = "/home/ludwig";
        username = "ludwig";
      };
      
      # Set helix as default editor for headless server
      programs.helix.defaultEditor = true;
    };
  }
)