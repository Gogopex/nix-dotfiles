lib:
lib.darwinSystem' {
  imports = [
    ../profiles/darwin-mbp.nix
  ]
  ++ lib.optional (builtins.pathExists ../profiles/package/mbp-old.nix) ../profiles/package/mbp-old.nix;

  networking.hostName = "mbp-old";
}
