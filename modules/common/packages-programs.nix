{ ... }:
{
  config = {
    home-manager.sharedModules = [
      {
        programs.zoxide.enable = true;

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        programs.btop = {
          enable = true;
          settings = {
            vim_keys = true;
            rounded_corners = true;
          };
        };
      }
    ];
  };
}
