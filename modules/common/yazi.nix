{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      
      settings = {
        show_hidden = true;
        preview = true;
      };
      
      keymap = {
        normal = {
          "." = "shell 'printf \"%s\" \"$0\" | pbcopy' --confirm";
          "ctrl-c" = "quit";
        };
      };
    };
  }];
}