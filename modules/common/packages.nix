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
        go
        rustc
        cargo
        rustfmt
        rust-analyzer
        nodejs
        bun
        deno
        python311
        poetry
        uv
        
        ghc
        cabal-install
        stack
        haskell-language-server
        
        maven
        openjdk
        
        elan
        
        volta
        
        nixfmt-rfc-style
        nil
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
        
        git-recent
        gh
        radicle-node
        
        wiki-tui
        tailscale
        ;
      
      agenix = inputs.agenix.packages.${pkgs.system}.default;
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
