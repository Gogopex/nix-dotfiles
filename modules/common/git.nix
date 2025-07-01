{ lib, ... }: let
  inherit (lib) enabled merge;
in merge {
  home-manager.sharedModules = [(homeArgs: let
    homeConfig = homeArgs.config;
  in {
    programs.git = enabled {
      userName  = homeConfig.programs.jujutsu.settings.user.name;
      userEmail = homeConfig.programs.jujutsu.settings.user.email;
      
      extraConfig = {
        pull.rebase = false;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        merge.conflictstyle = "diff3";
        merge.conflictStyle = "zdiff3";
        rebase.autosquash = true;
        diff.colorMoved = "default";
        
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          light = false;
          line-numbers = true;
          side-by-side = false;
          syntax-theme = "gruvbox-dark";
        };
      };
      
      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        last = "log -1 HEAD";
        
        l = "log --oneline --graph --decorate";
        la = "log --oneline --graph --decorate --all";
        
        d = "diff";
        dc = "diff --cached";
        
        a = "add";
        c = "commit";
        ca = "commit -a";
        
        unstage = "reset HEAD --";
        
        visual = "!gitk";
      };
    };
  })];
}
