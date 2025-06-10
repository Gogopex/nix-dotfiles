{ pkgs, ... }:

let mod = "ctrl-space";
in {
  age.secrets = {
    anthropic-api-key.file = ../../secrets/anthropic-api-key.age;
    openai-api-key.file = ../../secrets/openai-api-key.age;
    gemini-api-key.file = ../../secrets/gemini-api-key.age;
    deepseek-api-key.file = ../../secrets/deepseek-api-key.age;
  };
  system.stateVersion = 7;
  system.primaryUser  = "ludwig";

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
      mode = {
        main = {
          binding = {
            "ctrl-space" = "mode move";   # leader

            h          = "focus left";
            j          = "focus down";
            k          = "focus up";
            l          = "focus right";

            "shift-h"  = "move left";
            "shift-j"  = "move down";
            "shift-k"  = "move up";
            "shift-l"  = "move right";

            f = "fullscreen";
          };
        };
      };
    };
  };
}
