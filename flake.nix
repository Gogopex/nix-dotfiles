{
  description = "macOS dev environment";

  inputs = {
    nixpkgs.url        = "github:NixOS/nixpkgs/nixos-25.05";
    ghosttySrc.url     = "github:ghostty-org/ghostty";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url   = "github:LnL7/nix-darwin";
    flake-utils.url  = "github:numtide/flake-utils";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager
            , flake-utils, ghosttySrc, agenix, ... }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.hello;
      })
    // {

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./hosts/macbook/darwin.nix
          home-manager.darwinModules.home-manager
          agenix.darwinModules.default

          {
            users.users.ludwig.home = "/Users/ludwig";

            # pass extra args into every HM module
            home-manager.extraSpecialArgs = { inherit ghosttySrc; };

            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;

            home-manager.users.ludwig =
              import ./hosts/macbook/home.nix;
          }
        ];
      };
    };
}
