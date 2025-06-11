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
    casks           = [ "raycast" ];
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

  services.aerospace = {
    enable  = true;
    package = pkgs.aerospace;
    settings = {
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      accordion-padding = 0;
      automatically-unhide-macos-hidden-apps = true;
      gaps.inner.horizontal = 0;
      gaps.inner.vertical   = 0;
      gaps.outer = {
        left   = 0; right  = 0;
        top    = 0; bottom = 0;
      };
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      mode = {
        main.binding = {
          "${mod}-h"        = "focus left";
          "${mod}-j"        = "focus down";
          "${mod}-k"        = "focus up";
          "${mod}-l"        = "focus right";
          "${mod}-shift-h"  = "move left";
          "${mod}-shift-j"  = "move down";
          "${mod}-shift-k"  = "move up";
          "${mod}-shift-l"  = "move right";
          "${mod}-f"        = "fullscreen";
          "${mod}-m"        = "mode move";
        };
        move.binding = {
          h   = "move left";
          j   = "move down";
          k   = "move up";
          l   = "move right";
          esc = "mode main";
        };
      };
    };
  };
}
