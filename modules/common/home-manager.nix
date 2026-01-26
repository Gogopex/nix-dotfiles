{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs;
      inherit (inputs) zjstatus;
    };

    sharedModules = [
      {
        imports = [ ./theme.nix ];
        home.username = config.system.primaryUser or "ludwig";
        programs.home-manager.enable = true;
        manual.manpages.enable = false;
        manual.html.enable = false;
        manual.json.enable = false;
      }
    ];
  };
}
