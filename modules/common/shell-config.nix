{ lib, ... }:
{
  options = {
    userShell = lib.mkOption {
      type = lib.types.enum [ "fish" "nushell" ];
      default = "fish";
      description = "The shell to use for the user. Can be 'fish' or 'nushell'.";
    };
  };
}