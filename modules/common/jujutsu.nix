{ config, lib, pkgs, ... }: let
  inherit (lib) enabled merge mkIf;
in merge {
  home-manager.sharedModules = [{
    programs.jujutsu = enabled {
      settings = {
        # User configuration - this is the source of truth
        user.name  = "ludwig";
        user.email = "gogopex@gmail.com";
        
        # UI settings
        ui.default-command = "log";
        ui.diff-editor = ":builtin";
        ui.graph.style = if config.theme.cornerRadius > 0 then "curved" else "square";
        
        # Useful aliases from NCC
        aliases = {
          # Navigation
          ".." = [ "edit" "@-" ];
          ",," = [ "edit" "@+" ];
          
          # Git operations
          fetch = [ "git" "fetch" ];
          f     = [ "git" "fetch" ];
          push  = [ "git" "push" ];
          p     = [ "git" "push" ];
          clone = [ "git" "clone" "--colocate" ];
          cl    = [ "git" "clone" "--colocate" ];
          init  = [ "git" "init" "--colocate" ];
          i     = [ "git" "init" "--colocate" ];
          
          # Basic operations
          a  = [ "abandon" ];
          c  = [ "commit" ];
          ci = [ "commit" "--interactive" ];
          d  = [ "diff" ];
          e  = [ "edit" ];
          
          # Log variations
          l   = [ "log" ];
          la  = [ "log" "--revisions" "::" ];
          ls  = [ "log" "--summary" ];
          lsa = [ "log" "--summary" "--revisions" "::" ];
          lp  = [ "log" "--patch" ];
          lpa = [ "log" "--patch" "--revisions" "::" ];
          
          # Other operations
          r   = [ "rebase" ];
          res = [ "resolve" ];
          s   = [ "squash" ];
          si  = [ "squash" "--interactive" ];
          sh  = [ "show" ];
          u   = [ "undo" ];
        };
        
        # Git integration
        git.auto-local-bookmark = true;
      };
    };
  }];
}