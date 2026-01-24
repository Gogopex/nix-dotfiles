{ ... }:
{
  home-manager.sharedModules = [
    {
      xdg.configFile."nix/nix.conf".text = ''
        accept-flake-config = true
        eval-cache = true
        max-jobs = 6
        cores = 4
      '';
    }
  ];
}
