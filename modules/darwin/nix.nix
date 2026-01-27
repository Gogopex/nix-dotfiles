{ ... }:
{
  documentation.enable = false;

  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
    };
  };
}
