{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;

  environment.systemPackages = with pkgs; [
    git
    fish
    grc
  ];
  environment.pathsToLink = [
    "/share/zsh"
    "/share/fish"
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
}
