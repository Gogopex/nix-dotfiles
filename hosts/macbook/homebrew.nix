{ ... }: {
  homebrew = {
    enable = true;
    global.brewfile = true;
    
    casks = [
      "raycast"
      "orbstack"
      "hammerspoon"
    ];
    
    brews = [
      "displayplacer"
      "switchaudio-osx"
      "gh"
    ];
  };
}