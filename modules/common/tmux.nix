{
  config,
  lib,
  pkgs,
  ...
}:

{
  home-manager.sharedModules = [
    {
      programs.tmux = {
        enable = true;
        prefix = "C-Space";
        mouse = true;
        baseIndex = 1;
        clock24 = true;
        terminal = "screen-256color";
        historyLimit = 10000;
        escapeTime = 0;

        extraConfig = # fish
          ''
            set -ga terminal-overrides ",*256col*:Tc"

            set -g status-position bottom
            set -g status-bg colour234
            set -g status-fg colour137

            set -g pane-border-style fg=colour238
            set -g pane-active-border-style fg=colour51

            bind r source-file ~/.tmux.conf \; display "Reloaded!"

            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
          '';
      };
    }
  ];
}
