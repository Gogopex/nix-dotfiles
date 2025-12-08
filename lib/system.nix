inputs: self: super:
let
  inherit (self)
    attrValues
    filter
    getAttrFromPath
    hasAttrByPath
    collectNix
    ;

  modulesCommonRaw = collectNix ../modules/common;
  homeManagerCompatModule = ../modules/common/home-manager-compat.nix;
  homeManagerCompatModuleStr = builtins.toString homeManagerCompatModule;
  modulesCommon = modulesCommonRaw |> filter (m: builtins.toString m != homeManagerCompatModuleStr);
  modulesDarwin = collectNix ../modules/darwin;
  modulesNixOS = if builtins.pathExists ../modules/nixos then collectNix ../modules/nixos else [ ];

  collectInputs =
    let
      inputs' = attrValues inputs;
    in
    path: inputs' |> filter (hasAttrByPath path) |> map (getAttrFromPath path);

  inputModulesDarwin = collectInputs [
    "darwinModules"
    "default"
  ];

  inputModulesNixOS = collectInputs [
    "nixosModules"
    "default"
  ];

  inputOverlays = [ (import ../overlays) ] ++ collectInputs [
    "overlays"
    "default"
  ];
  overlayModule = {
    nixpkgs.overlays = inputOverlays;
  };

  specialArgs = inputs // {
    inherit inputs;
    lib = self;
  };
in
{
  darwinSystem' =
    module:
    super.darwinSystem {
      inherit specialArgs;

      modules = [
        module
        overlayModule
      ]
      ++ modulesCommon
      ++ modulesDarwin
      ++ inputModulesDarwin;
    };

  nixosSystem' =
    module:
    super.nixosSystem {
      inherit specialArgs;

      modules = [
        module
        overlayModule
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ]
      ++ modulesCommon
      ++ modulesNixOS
      ++ inputModulesNixOS;
    };

  homeManagerConfiguration' =
    {
      system,
      username ? "ludwig",
      module,
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = inputOverlays;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Pass our extended lib to modules as a specialArg
      # But let home-manager use its own lib internally
      extraSpecialArgs = inputs // {
        inherit inputs;
        # Add our extensions to the lib that modules see
        lib =
          inputs.nixpkgs.lib
          // self
          // {
            # Keep home-manager's lib extensions
            hm = inputs.home-manager.lib.hm;
          };
      };

      modules = [
        module
        {
          home.username = username;
          home.homeDirectory = "/home/${username}";
        }
        ../modules/common/home-manager-compat.nix
      ]
      ++ (filter (m: m != ../modules/common/home-manager.nix) modulesCommon);
    };
}
