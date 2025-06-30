{ pkgs, ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # Nix is managed externally
  nix.enable = false;
  
  # Basic system packages
  environment.systemPackages = with pkgs; [ git ];
  environment.pathsToLink = [ "/share/zsh" ];
  
  # Shell configuration
  programs.fish.enable = true;
}