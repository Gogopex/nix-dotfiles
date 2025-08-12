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
      "protobuf"
      "buf"
    ];
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];
}
