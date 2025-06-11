{ pkgs, ... }:

let mod = "alt";
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
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      accordion-padding = 0;     
      automatically-unhide-macos-hidden-apps = true;

      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };
      
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      
      mode = {
        main = {
          binding = {
            "${mod}-h" = "focus left";
            "${mod}-j" = "focus down";
            "${mod}-k" = "focus up";
            "${mod}-l" = "focus right";

            "${mod}-shift-h" = "move left";
            "${mod}-shift-j" = "move down";
            "${mod}-shift-k" = "move up";
            "${mod}-shift-l" = "move right";

            "${mod}-f" = "fullscreen";
            "${mod}-m" = "mode move";
          };
        };
        move = {
          binding = {
            h = "move left";
            j = "move down";
            k = "move up";
            l = "move right";
            esc = "mode main";
          };
        };
      };
    };
  };
}
