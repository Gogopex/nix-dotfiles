inputs: self: super:
let
  inherit (self)
    attrValues
    filter
    getAttrFromPath
    hasAttrByPath
    collectNix
    ;

  modulesCommon = collectNix ../modules/common;
  modulesDarwin = collectNix ../modules/darwin;
  modulesNixOS = 
    if builtins.pathExists ../modules/nixos
    then collectNix ../modules/nixos
    else [];

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

  inputOverlays = collectInputs [
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

      modules =
        [
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

      modules =
        [
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
}
