{ ... }:
{
  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.cleanup = "uninstall";

    taps = [
      "shivammathur/php"
    ];

    casks = [
      "orbstack"
    ];

    brews = [
      "protobuf"
      "buf"
      "shivammathur/php/php"
      # "shivammathur/php/php@8.2"
      "shivammathur/php/php@8.3"
      "composer"
    ];
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];
}
