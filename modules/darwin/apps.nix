{ lib, inputs, ... }:
let
  hmLib = inputs.home-manager.lib;
in
{
  home-manager.sharedModules = [
    {
      home.activation.installMacApps = hmLib.hm.dag.entryAfter [ "linkGeneration" ] ''
        src="$HOME/Applications/Home Manager Apps"
        dst="$HOME/Applications/Nix Apps"
        lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

        if [ ! -d "$src" ]; then
          exit 0
        fi

        mkdir -p "$dst"
        find "$dst" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

        find "$src" -mindepth 1 -maxdepth 1 -name '*.app' -print0 | while IFS= read -r -d "" app; do
          app_name=$(basename "$app")
          rsync -aL --delete "$app/" "$dst/$app_name/"
        done

        if [ -x "$lsregister" ]; then
          find "$dst" -mindepth 1 -maxdepth 1 -name '*.app' -exec "$lsregister" -f {} +
        fi

        if command -v mdimport >/dev/null 2>&1; then
          find "$dst" -mindepth 1 -maxdepth 1 -name '*.app' -exec mdimport {} +
        fi
      '';
    }
  ];
}
