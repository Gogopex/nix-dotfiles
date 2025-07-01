{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      mouse = true;
      baseIndex = 1;
      clock24 = true;
      terminal = "screen-256color";
      historyLimit = 10000;
      escapeTime = 0;
      
      extraConfig = ''
        # Better colors
        set -ga terminal-overrides ",*256col*:Tc"
        
        # Status bar
        set -g status-position bottom
        set -g status-bg colour234
        set -g status-fg colour137
        
        # Pane borders
        set -g pane-border-style fg=colour238
        set -g pane-active-border-style fg=colour51
        
        # Easy reload
        bind r source-file ~/.tmux.conf \; display "Reloaded!"
        
        # Better splitting
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        
        # Vim-style pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
      '';
    };
  }];
}