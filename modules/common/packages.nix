{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    attrValues
    mkOption
    optionalAttrs
    types
    ;

  hmLib = inputs.home-manager.lib.hm;
  defaultNodeVersion = "24.14.1";
  homeDirectory =
    if config.isDarwin then "/Users/${config.user.name}" else "/home/${config.user.name}";
  voltaHome = "${homeDirectory}/.volta";

  corePackages = {
    inherit (pkgs)
      bandwhich
      zoxide
      fzf
      ripgrep
      bat
      fd
      eza
      git
      curl
      wget
      broot

      zellij
      delta

      nixfmt-rfc-style
      nixd
      nh

      tokei
      hyperfine
      just
      cmake
      ninja
      tldr
      glow
      lazygit
      procs
      jq
      yq-go
      tree
      bottom
      sd

      dust
      uutils-coreutils-noprefix

      gh
      ;

    agenix = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  fullPackages = corePackages // {
    inherit (pkgs)
      # go
      # gopls
      # gofumpt
      # delve

      rustup
      lldb

      swift
      sourcekit-lsp
      swift-format

      bun
      deno
      typescript-language-server
      vscode-js-debug

      prettier
      vscode-langservers-extracted
      yaml-language-server

      python311
      poetry
      uv
      ty
      ruff
      # black

      # ghc
      # cabal-install
      # haskell-language-server
      # ormolu
      # fourmolu
      # stylish-haskell

      # maven
      # openjdk
      # jdt-language-server
      # google-java-format

      volta

      lsp-ai
      mutagen

      ffmpeg
      imagemagick
      pandoc
      graphviz

      # postgresql
      # redis
      sqlite
      duckdb

      git-recent
      radicle-node

      wiki-tui
      tailscale

      vault
      argocd

      claude-code
      biome
      ast-grep
      ;
  };

  profilePackages = if config.packages.profile == "full" then fullPackages else corePackages;

  desktopPackages = optionalAttrs config.isDesktop {
    inherit (pkgs)
      obsidian
      zotero
      ;
  };

  zedPackage = optionalAttrs config.isDesktop {
    inherit (pkgs) zed-editor;
  };
in
{
  options = {
    packages.profile = mkOption {
      type = types.enum [
        "core"
        "full"
      ];
      default = "core";
    };
  };

  config = {
    home-manager.sharedModules = [
      {
        home.packages = attrValues (profilePackages // desktopPackages // zedPackage);
        home.sessionPath = [ "${voltaHome}/bin" ];
        home.sessionVariables = {
          VOLTA_HOME = voltaHome;
        } // optionalAttrs config.isDarwin {
          CGO_LDFLAGS = "-L${pkgs.darwin.libresolv}/lib";
        };

        home.activation.voltaDefaultNode = hmLib.dag.entryAfter [ "writeBoundary" ] ''
          export VOLTA_HOME="${voltaHome}"
          export PATH="$VOLTA_HOME/bin:$PATH"

          if command -v volta >/dev/null 2>&1; then
            platform_file="$VOLTA_HOME/tools/user/platform.json"
            if ! [ -f "$platform_file" ] || ! grep -q "\"runtime\": \"${defaultNodeVersion}\"" "$platform_file"; then
              $DRY_RUN_CMD volta install node@${defaultNodeVersion}
            fi

            for tool in node npm npx; do
              target="$VOLTA_HOME/bin/$tool"
              if [ -n "''${DRY_RUN:-}" ]; then
                echo "write $target"
                continue
              fi

              rm -f "$target"
              printf '%s\n' \
                '#!/bin/sh' \
                'set -eu' \
                'tool=$(basename "$0")' \
                'exec "$(volta which "$tool")" "$@"' > "$target"
              chmod +x "$target"
            done

            pi_cli="${homeDirectory}/.npm-global/lib/node_modules/@mariozechner/pi-coding-agent/dist/cli.js"
            pi_bin="$VOLTA_HOME/bin/pi"
            if [ -f "$pi_cli" ]; then
              if [ -n "''${DRY_RUN:-}" ]; then
                echo "write $pi_bin"
              else
                mkdir -p "$(dirname "$pi_bin")"
                rm -f "$pi_bin"
                cat > "$pi_bin" <<'EOF'
#!/bin/sh
set -eu

VOLTA_HOME="${voltaHome}"
PI_CLI="${homeDirectory}/.npm-global/lib/node_modules/@mariozechner/pi-coding-agent/dist/cli.js"
NPM_PREFIX="${homeDirectory}/.npm-global"

if [ ! -x "$VOLTA_HOME/bin/node" ]; then
  echo "pi: missing Volta node shim at $VOLTA_HOME/bin/node" >&2
  exit 127
fi

if [ ! -f "$PI_CLI" ]; then
  echo "pi: missing CLI at $PI_CLI" >&2
  exit 127
fi

export VOLTA_HOME
export NPM_CONFIG_PREFIX="$NPM_PREFIX"
export PATH="$VOLTA_HOME/bin:$NPM_PREFIX/bin:$PATH"

exec "$VOLTA_HOME/bin/node" "$PI_CLI" "$@"
EOF
                chmod +x "$pi_bin"
              fi
            fi
          fi
        '';

        programs.zoxide.enable = true;
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        programs.btop = {
          enable = true;
          settings = {
            vim_keys = true;
            rounded_corners = true;
          };
        };
      }
    ];
  };
}
