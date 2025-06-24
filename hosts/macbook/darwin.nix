# hosts/macbook/darwin.nix  ── final, minimal form
{ pkgs, ... }:

let mod = "alt";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion  = 6;
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
    casks           = [ "raycast" "orbstack" "hammerspoon" ];
    brews           = [ "displayplacer" "switchaudio-osx" "gh" ];
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
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = false;
      include-date = true;
      show-thumbnail = true;
      target = "file";
    };
  };

  system.keyboard = {
    enableKeyMapping       = true;
    remapCapsLockToControl = true;
  };

  programs.fish.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  # ensure USB services are properly managed
  system.activationScripts.usbservices.text = ''
    echo "Ensuring USB services are running..."
    launchctl bootout gui/$(id -u) /System/Library/LaunchAgents/com.apple.USBAgent.plist 2>/dev/null || true
    launchctl bootstrap gui/$(id -u) /System/Library/LaunchAgents/com.apple.USBAgent.plist 2>/dev/null || true
  '';

  # comprehensive display detection and management services
  launchd.user.agents = {
    displaydetection = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/killall" "-USR1" "Dock" ];
        RunAtLoad = true;
        WatchPaths = [ "/System/Library/Displays" ];
      };
    };
    
    # Enhanced display detection with hardware probe
    displayprobe = {
      serviceConfig = {
        ProgramArguments = [ "/bin/sh" "-c" "system_profiler SPDisplaysDataType > /dev/null 2>&1" ];
        RunAtLoad = true;
        StartInterval = 30; # Check every 30 seconds
      };
    };
    
    # USB device monitoring for external displays
    usbmonitor = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/killall" "-USR1" "SystemUIServer" ];
        RunAtLoad = true;
        WatchPaths = [ "/dev" ];
      };
    };
  };

  # screenshot shortcut remapping via activation script
  # @FIXME: I dont think it is needed anymore? had an issue with macos keybind conflicts
  system.activationScripts.screenshots.text = ''
    echo "Configuring screenshot shortcuts..."
    
    # Screenshot shortcuts in com.apple.symbolichotkeys:
    # 28: Save picture of screen as a file (default: Shift+Cmd+3)
    # 29: Copy picture of screen to the clipboard (default: Ctrl+Shift+Cmd+3)
    # 30: Save picture of selected area as a file (default: Shift+Cmd+4)
    # 31: Copy picture of selected area to the clipboard (default: Ctrl+Shift+Cmd+4)
    # 184: Screenshot and recording options (default: Shift+Cmd+5)
    
    # Remap screenshot shortcuts to use Ctrl+Alt instead of Shift+Cmd
    # Format: parameters = (keycode, modifier_flags, reserved)
    # modifier_flags: 1048576=Cmd, 131072=Shift, 262144=Ctrl, 524288=Alt
    # Combined: Ctrl+Alt = 262144+524288 = 786432
    
    # Save picture of screen as file: Ctrl+Alt+3
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 28 '
    {
      enabled = 1;
      value = {
        parameters = (51, 786432, 0);
        type = standard;
      };
    }'
    
    # Copy picture of screen to clipboard: Ctrl+Alt+Shift+3
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 29 '
    {
      enabled = 1;
      value = {
        parameters = (51, 917504, 0);
      };
    }'
    
    # Save picture of selected area as file: Ctrl+Alt+4
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 30 '
    {
      enabled = 1;
      value = {
        parameters = (52, 786432, 0);
        type = standard;
      };
    }'
    
    # Copy picture of selected area to clipboard: Ctrl+Alt+Shift+4
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 '
    {
      enabled = 1;
      value = {
        parameters = (52, 917504, 0);
        type = standard;
      };
    }'
    
    # Screenshot and recording options: Ctrl+Alt+5
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 184 '
    {
      enabled = 1;
      value = {
        parameters = (53, 786432, 0);
        type = standard;
      };
    }'
    
    # Apply the changes immediately without restart
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    
    echo "Screenshot shortcuts configured:"
    echo "  Ctrl+Alt+3: Save full screen to file"
    echo "  Ctrl+Alt+Shift+3: Copy full screen to clipboard"
    echo "  Ctrl+Alt+4: Save selected area to file"
    echo "  Ctrl+Alt+Shift+4: Copy selected area to clipboard"
    echo "  Ctrl+Alt+5: Screenshot and recording options"
  '';
}
