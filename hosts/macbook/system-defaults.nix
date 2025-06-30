{ ... }: {
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
  };
  
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}