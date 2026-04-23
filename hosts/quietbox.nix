lib:
lib.homeManagerConfiguration' {
  system = "x86_64-linux";
  username = "ludwig";
  homeDirectory = "/home/ludwig";
  commonModules = [ ];
  module = {
    imports = [
      ../profiles/linux-homelab-node.nix
    ]
    ++ lib.optional (builtins.pathExists ../profiles/package/quietbox.nix) ../profiles/package/quietbox.nix;
  };
}
