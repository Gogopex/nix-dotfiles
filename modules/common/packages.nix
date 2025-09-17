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
    merge
    optionalAttrs
    ;
in
merge {
  home-manager.sharedModules = [
    {
      home.packages = attrValues (
        {
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
            direnv
            broot

            zellij
            delta

            zig
            zls
            odin
            ols
            go
            gopls
            gofumpt
            delve
            rustup
            lldb
            nodejs
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
            pyright
            ruff
            black

            ghc
            cabal-install
            stack
            haskell-language-server
            ormolu
            fourmolu
            stylish-haskell

            maven
            openjdk
            jdt-language-server
            google-java-format

            elan

            volta

            nixfmt-rfc-style
            nixd
            lsp-ai
            nh

            tokei
            mutagen
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

            ffmpeg
            imagemagick
            pandoc
            graphviz

            postgresql
            redis
            sqlite
            duckdb

            git-recent
            gh
            radicle-node

            wiki-tui
            tailscale
            
            vault
            argocd
            
            claude-code
            biome
            llm
            ;

          agenix = inputs.agenix.packages.${pkgs.system}.default;
          haskell-debug-adapter = pkgs.haskellPackages.haskell-debug-adapter;
          ghci-dap = pkgs.haskellPackages.ghci-dap;
        }
        // optionalAttrs config.isDesktop {
          inherit (pkgs)
            aerospace
            obsidian
            zotero
            zed-editor
            ;
        }
      );

      programs.zoxide.enable = true;
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
          rounded_corners = true;
        };
      };
    }
  ];
}
