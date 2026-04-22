lib:
let
  inherit (lib) collectNix remove;
in
import ../darwin-workstation-default.nix {
  inherit lib;
  hostName = "mbp";
  hostModules = collectNix ./. |> remove ./default.nix |> remove ./home.nix;
}
