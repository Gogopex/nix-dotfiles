{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) attrValues merge mkIf optionalAttrs;
in merge {
  home-manager.sharedModules = [{
    home.packages = attrValues ({
      inherit (pkgs)
        # Core utilities
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
        
        # Terminal multiplexers and tools
        zellij
        delta
        
        # Programming languages and tools
        zig
        zls
        go
        rustc
        cargo
        rustfmt
        rust-analyzer
        nodejs
        
        # Nix tools
        nixfmt-rfc-style
        nil
        nh
        
        # Development tools
        tokei
        mutagen
        hyperfine
        just
        tldr
        glow
        lazygit
        procs
        
        # System tools
        dust
        uutils-coreutils-noprefix
        
        # Git tools
        git-recent
        gh
        
        # Other tools
        wiki-tui
        tailscale
        ;
      
      # Add agenix from inputs
      agenix = inputs.agenix.packages.${pkgs.system}.default;
    } // optionalAttrs config.isDesktop {
      inherit (pkgs)
        # Desktop-only packages
        obsidian
        ;
    });
    
    # Enable some programs that need configuration
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