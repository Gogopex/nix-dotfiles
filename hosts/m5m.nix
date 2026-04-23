lib:
lib.darwinSystem' {
  imports = [
    ../profiles/darwin-workstation.nix
  ]
  ++ lib.optional (builtins.pathExists ../profiles/package/m5m.nix) ../profiles/package/m5m.nix;

  networking.hostName = "m5m";
}
