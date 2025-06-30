_: self: _: let
  inherit (self) mkOption;
  inherit (self.types) anything;
in {
  mkConst = value: mkOption {
    type      = anything;
    default   = value;
    readOnly  = true;
    internal  = true;
    visible   = false;
  };

  mkValue = default: mkOption {
    type    = anything;
    inherit default;
  };
}