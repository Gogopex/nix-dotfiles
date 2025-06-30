inputs: self: super: let
  inherit (self) attrValues filter getAttrFromPath hasAttrByPath collectNix;

  modulesCommon = collectNix ../modules/common;
  modulesDarwin = collectNix ../modules/darwin;

  collectInputs = let
    inputs' = attrValues inputs;
  in path: inputs'
    |> filter (hasAttrByPath path)
    |> map (getAttrFromPath path);

  inputModulesDarwin = collectInputs [ "darwinModules" "default" ];

  inputOverlays = collectInputs [ "overlays" "default" ];
  overlayModule = { nixpkgs.overlays = inputOverlays; };

  specialArgs = inputs // {
    inherit inputs;
    lib = self;
  };
in {
  darwinSystem' = module: super.darwinSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule
    ] ++ modulesCommon
      ++ modulesDarwin
      ++ inputModulesDarwin;
  };
}