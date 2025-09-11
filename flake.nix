{
  description = "dev env";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io/"
      "https://cache.privatevoid.net"
      "https://nix-community.cachix.org/"
    ];

    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    builders-use-substitutes = true;
    flake-registry = "";
    http-connections = 50;
    show-trace = true;
    warn-dirty = false;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };

    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      inherit (builtins) readDir;
      inherit (nixpkgs.lib)
        attrsToList
        const
        groupBy
        listToAttrs
        mapAttrs
        nameValuePair
        ;

      lib' = nixpkgs.lib.extend (_: _: nix-darwin.lib);
      lib = lib'.extend <| import ./lib inputs;

      hostsByType =
        readDir ./hosts
        |> mapAttrs (name: const <| import ./hosts/${name} lib)
        |> attrsToList
        |> groupBy (
          { name, value }:
          if value ? class && value.class == "nixos" then "nixosConfigurations" else "darwinConfigurations"
        )
        |> mapAttrs (const listToAttrs);

      darwinConfigs =
        (hostsByType.darwinConfigurations or { })
        |> attrsToList
        |> map ({ name, value }: nameValuePair name value.config)
        |> listToAttrs;
      
      nixosConfigs =
        (hostsByType.nixosConfigurations or { })
        |> attrsToList
        |> map ({ name, value }: nameValuePair name value.config)
        |> listToAttrs;
    in
    hostsByType
    // darwinConfigs
    // nixosConfigs
    // {
      inherit lib;
      
      # Add home-manager configurations for standalone Linux systems
      homeConfigurations = 
        let
          quietboxImport = import ./hosts/quietbox lib;
        in
        if quietboxImport ? config then {
          "ludwig@quietbox" = quietboxImport.config;
        } else { };
    };
}
