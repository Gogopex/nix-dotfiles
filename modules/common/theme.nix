{ lib, ... }: let
  inherit (lib) mkValue;
in {
  options.theme = mkValue {
    # UI metrics
    cornerRadius = 4;
    borderWidth  = 2;
    margin       = 0;
    padding      = 8;

    # Font configuration
    font.size.normal = 16;
    font.size.big    = 20;
    font.size.small  = 14;

    font.sans.name    = "SF Pro Display";
    font.sans.package = null; # System font on macOS

    font.mono.name    = "Berkeley Mono";
    font.mono.package = null; # Berkeley Mono is manually installed on macOS

    # Colors (Gruvbox Dark Hard theme)
    colors = {
      # Background colors
      bg0_h    = "#1d2021"; # hard
      bg0      = "#282828"; # normal
      bg0_s    = "#32302f"; # soft
      bg1      = "#3c3836";
      bg2      = "#504945";
      bg3      = "#665c54";
      bg4      = "#7c6f64";

      # Foreground colors
      fg0      = "#fbf1c7";
      fg1      = "#ebdbb2";
      fg2      = "#d5c4a1";
      fg3      = "#bdae93";
      fg4      = "#a89984";

      # Accent colors
      red      = "#fb4934";
      green    = "#b8bb26";
      yellow   = "#fabd2f";
      blue     = "#83a598";
      purple   = "#d3869b";
      aqua     = "#8ec07c";
      orange   = "#fe8019";
      gray     = "#928374";

      # Bright variants
      bright_red    = "#fb4934";
      bright_green  = "#b8bb26";
      bright_yellow = "#fabd2f";
      bright_blue   = "#83a598";
      bright_purple = "#d3869b";
      bright_aqua   = "#8ec07c";
      bright_orange = "#fe8019";
      bright_gray   = "#a89984";
    };

    # Application-specific overrides can be added here
    overrides = {
      ghostty = {};
      zellij = {};
    };
  };
}
