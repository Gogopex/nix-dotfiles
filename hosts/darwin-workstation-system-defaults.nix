{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      show-process-indicators = true;
      tilesize = 48;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = false;
      include-date = true;
      show-thumbnail = true;
      target = "file";
    };

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "65" = {
            enabled = false;
          };
        };
      };
      "com.kagi.orion" = {
        NSUserKeyEquivalents = {
          "Show Sidebar" = "@$s";
          "Hide Sidebar" = "@$s";
        };
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
