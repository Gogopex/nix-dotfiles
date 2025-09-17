{ lib, ... }:
let
  inherit (lib) mkOption types mkValue;
in
{
  options.user = {
    name = mkOption {
      type = types.str;
      default = "ludwig";
      description = "Username for git, jujutsu, and other tools";
    };

    email = mkOption {
      type = types.str;
      default = "gogopex@gmail.com";
      description = "Email address for git, jujutsu, and other tools";
    };

    editor = mkOption {
      type = types.str;
      default = "hx";
      description = "Default editor";
    };
  };

  config.user = mkValue {
    name = "ludwig";
    email = "gogopex@gmail.com";
    editor = "hx";
  };
}