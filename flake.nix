{
  description = "macOS dev environment";

  nixConfig = {
    experimental-features = ["flakes" "nix-command" "pipe-operators"];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };
    
    ghosttySrc.url = "github:ghostty-org/ghostty";
    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs = inputs @ { nixpkgs, nix-darwin, home-manager, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs nameValuePair;
    
    # Extend lib with our custom functions and nix-darwin's lib
    lib' = nixpkgs.lib.extend (_: _: nix-darwin.lib);
    lib = lib'.extend <| import ./lib inputs;
    
    # Read all host configurations
    hostsByType = readDir ./hosts
      |> mapAttrs (name: const <| import ./hosts/${name} lib)
      |> attrsToList
      |> groupBy ({ name, value }:
        if value ? class && value.class == "nixos" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);
    
    # Extract just the configs for convenience
    hostConfigs = (hostsByType.darwinConfigurations or {})
      |> attrsToList
      |> map ({ name, value }: nameValuePair name value.config)
      |> listToAttrs;
  in hostsByType // hostConfigs // {
    inherit lib;
  };
}