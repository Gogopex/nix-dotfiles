{ ... }:
{
  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.cleanup = "uninstall";

    casks = [
      "orbstack"
      "hammerspoon"
    ];

    brews = [
      "displayplacer"
      "gh"
    ];
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];
}
