lib:
lib.homeManagerConfiguration' {
  system = "x86_64-linux";
  username = "ludwig";
  module = {
    imports = [ ./home.nix ];
    home.stateVersion = "24.11";
  };
}
