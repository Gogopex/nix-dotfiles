_: self: _:
let
  inherit (self) mkOption;
in
{
  mkConst =
    value:
    mkOption {
      default = value;
      readOnly = true;
    };

  mkValue =
    default:
    mkOption {
      inherit default;
    };
}
