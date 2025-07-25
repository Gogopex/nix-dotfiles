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
      "gh"
    ];
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];
}
