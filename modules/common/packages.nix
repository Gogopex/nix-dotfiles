{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) attrValues merge mkIf optionalAttrs;
in merge {
  home-manager.sharedModules = [{
    home.packages = attrValues ({
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
        rustc
        cargo
        rustfmt
        rust-analyzer
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
        nh
        
        tokei
        mutagen
        hyperfine
        just
        tldr
        glow
        lazygit
        procs
        jq
        yq-go
        tree
        bottom
        
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
        ;
      
      agenix = inputs.agenix.packages.${pkgs.system}.default;
      haskell-debug-adapter = pkgs.haskellPackages.haskell-debug-adapter;
      ghci-dap = pkgs.haskellPackages.ghci-dap;
    } // optionalAttrs config.isDesktop {
      inherit (pkgs)
        aerospace
        obsidian
        zotero
        zed-editor
        ;
    });
    
    programs.zoxide.enable = true;
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        rounded_corners = true;
      };
    };
  }];
}
