lib:
let
  inherit (lib) inputs;
  
  system = "x86_64-linux";
  
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  
  extraSpecialArgs = {
    inherit inputs;
    inherit (inputs) zjstatus;
  };
  
  modules = [
    ./home.nix
    {
      home = {
        username = "ludwig";
        homeDirectory = "/home/ludwig";
        stateVersion = "24.11";
      };
    }
  ];
}