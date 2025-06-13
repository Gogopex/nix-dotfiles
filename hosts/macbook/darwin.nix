# hosts/macbook/darwin.nix  ── final, minimal form
{ pkgs, ... }:

let mod = "alt";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion  = 7;
  system.primaryUser   = "ludwig";

  age.secrets = {
    anthropic-api-key.file = ../../secrets/anthropic-api-key.age;
    openai-api-key.file    = ../../secrets/openai-api-key.age;
    gemini-api-key.file    = ../../secrets/gemini-api-key.age;
    deepseek-api-key.file  = ../../secrets/deepseek-api-key.age;
  };

  nix.enable = false;

  environment.systemPackages = with pkgs; [ git ];

  homebrew = {
    enable          = true;
    global.brewfile = true;
    casks           = [ "raycast" "orbstack" ];
  };

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat         = 15;
      KeyRepeat                = 2;
    };
    dock = {
      autohide                = true;
      show-process-indicators = true;
      tilesize                = 48;
    };
  };

  system.keyboard = {
    enableKeyMapping       = true;
    remapCapsLockToControl = true;
  };

  programs.fish.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  # aerospace is now configured in home-manager (programs.aerospace)
}
