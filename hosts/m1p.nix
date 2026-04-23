lib:
lib.darwinSystem' {
  imports = [
    ../profiles/darwin-workstation.nix
  ]
  ++ lib.optional (builtins.pathExists ../profiles/package/m1p.nix) ../profiles/package/m1p.nix;

  networking.hostName = "m1p";
}
