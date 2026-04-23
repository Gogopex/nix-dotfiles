lib:
lib.darwinSystem' {
  imports = [
    ../profiles/darwin-workstation.nix
  ]
  ++ lib.optional (builtins.pathExists ../profiles/package/mbp.nix) ../profiles/package/mbp.nix;

  networking.hostName = "mbp";
}
