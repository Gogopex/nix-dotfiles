{ ... }: {
  homebrew = {
    enable = true;
    global.brewfile = true;
    
    casks = [
      "orbstack"
      "hammerspoon"
    ];
    
    brews = [
      "displayplacer"
      "gh"
    ];
  };
}
