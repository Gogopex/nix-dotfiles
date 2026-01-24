{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
mkIf config.editors.ideavim.enable {
  home-manager.sharedModules = [
    {
      home.file.".ideavimrc".source = ../../cfg/ideavimrc;
    }
  ];
}
