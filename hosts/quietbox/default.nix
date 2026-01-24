lib:
lib.homeManagerConfiguration' {
  system = "x86_64-linux";
  username = "ludwig";
  module = {
    imports =
      [ ./home.nix ]
      ++ lib.optional (builtins.pathExists ./profile.nix) ./profile.nix;
    home.stateVersion = "24.11";
  };
}
