{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    programs.fish = {
      enable = true;
      
      shellAliases = {
        # Basic navigation and utilities
        ll = "eza -la";
        dr = "cd ~/dev";
        rl = "source ~/.config/fish/config.fish";
        
        # Better defaults
        cat = "bat";
        ps = "procs";
        du = "dust";
        diff = "delta";
        
        # Git shortcuts
        gs = "git status";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline --graph";
        ga = "git add";
        gd = "git diff";
        gco = "git checkout";
        
        # Zellij shortcuts
        zls = "zellij ls";
        zdel = "zellij delete-session";
        zforce = "zellij kill-session";
        zt = "NO_ZELLIJ=1 zellij attach -c";
        
        # Other utilities
        code = "cursor";
        vim = "nvim";
        vi = "nvim";
      };
      
      shellInit = ''
        # Set up environment variables
        set -gx EDITOR nvim
        set -gx VISUAL nvim
        
        # Better ls colors
        set -gx LS_COLORS "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
        
        # Disable fish greeting
        set fish_greeting
      '';
      
      functions = {
        mkcd = {
          description = "Create a directory and cd into it";
          body = ''
            mkdir -p $argv[1]
            cd $argv[1]
          '';
        };
        
        backup = {
          description = "Create a backup of a file";
          body = ''
            cp $argv[1] $argv[1].backup-(date +%Y%m%d-%H%M%S)
          '';
        };
        
        extract = {
          description = "Extract various archive formats";
          body = ''
            switch $argv[1]
              case '*.tar.bz2'
                tar xjf $argv[1]
              case '*.tar.gz'
                tar xzf $argv[1]
              case '*.bz2'
                bunzip2 $argv[1]
              case '*.gz'
                gunzip $argv[1]
              case '*.tar'
                tar xf $argv[1]
              case '*.tbz2'
                tar xjf $argv[1]
              case '*.tgz'
                tar xzf $argv[1]
              case '*.zip'
                unzip $argv[1]
              case '*.Z'
                uncompress $argv[1]
              case '*.7z'
                7z x $argv[1]
              case '*'
                echo "'$argv[1]' cannot be extracted"
            end
          '';
        };
      };
      
      interactiveShellInit = ''
        # Set up key bindings
        bind \cf 'yazi'
        bind \cr 'history | fzf | read -l result; and commandline $result'
        
        # Initialize zoxide
        zoxide init fish | source
        
        # Set up direnv hook
        direnv hook fish | source
      '';
    };
  }];
}