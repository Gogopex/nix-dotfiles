{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.user = {
    name = mkOption {
      type = types.str;
      default = "ludwig";
    };

    email = mkOption {
      type = types.str;
      default = "gogopex@gmail.com";
    };

    editor = mkOption {
      type = types.str;
      default = "hx";
    };
  };
}