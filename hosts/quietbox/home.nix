{ config, pkgs, lib, inputs, ... }:

{
  programs.home-manager.enable = true;
  programs.helix = import ../../modules/common/helix-config.nix;
  
  programs.fish = {
    enable = true;
    shellAliases = {
      dr = "home-manager switch --flake .#quietbox --extra-experimental-features 'nix-command flakes pipe-operators'";
      cat = "bat";
      ll = "ls -alh";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
    
    interactiveShellInit = ''
      set -gx EDITOR hx
      
      # Vi mode setup
      fish_vi_key_bindings
      setup_enhanced_vi_mode
      
      # Cursor shapes for different modes
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_replace underscore
      set -g fish_cursor_external line
      set -g fish_cursor_visual block
      
      # Key bindings
      function fish_user_key_bindings
        bind \c\; 'toggle_vim_mode'
      end
      
      # Zoxide
      zoxide init fish | source
    '';
    
    functions = {
      fish_greeting = ''
        set -l quotes (
          "What is impossible for you is not impossible for me." \
          "Ah, Stil, I live in an apocalyptic dream." \
          "Do not compete with what is happening." \
          "Greatness is a transitory experience."
        )
        echo $quotes[(random 1 (count $quotes))]
      '';
      
      fish_mode_prompt = ''
        switch $fish_bind_mode
          case default
            set_color -o brgreen
            echo -n "◆ "
            set_color normal
          case insert
            set_color -o bryellow
            echo -n "◇ "
            set_color normal
          case replace_one
            set_color -o brred
            echo -n "◈ "
            set_color normal
          case replace
            set_color -o brred
            echo -n "▓ "
            set_color normal
          case visual
            set_color -o brmagenta
            echo -n "◉ "
            set_color normal
        end
      '';
      
      setup_enhanced_vi_mode = ''
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_replace_one underscore
        set -g fish_cursor_replace underscore
        set -g fish_cursor_external line
        set -g fish_cursor_visual block
        
        bind -M default gh 'commandline -f beginning-of-line'
        bind -M default gl 'commandline -f end-of-line'
        bind -M default 0 'commandline -f beginning-of-line'
        bind -M default '\$' 'commandline -f end-of-line'
        
        bind -M visual gh 'commandline -f beginning-of-line'
        bind -M visual gl 'commandline -f end-of-line'
        bind -M visual 0 'commandline -f beginning-of-line'
        bind -M visual '\$' 'commandline -f end-of-line'
      '';
      
      toggle_vim_mode = ''
        if test "$fish_key_bindings" = "fish_vi_key_bindings"
          echo "Switching to default key bindings"
          fish_default_key_bindings
          set -g fish_key_bindings fish_default_key_bindings
        else
          echo "Switching to enhanced vim key bindings"
          fish_vi_key_bindings
          setup_enhanced_vi_mode
          set -g fish_key_bindings fish_vi_key_bindings
        end
      '';
    };
  };
  
  programs.git = {
    enable = true;
    userName = "ludwig";
    userEmail = "gogopex@gmail.com";
  };
  
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # If running interactively and fish exists, exec into it
      if [[ $- == *i* ]] && [ -z "$IN_FISH" ] && command -v fish &> /dev/null; then
        export IN_FISH=1
        exec fish
      fi
    '';
  };
  
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    curl
    wget
    htop
    btop
    ncdu
    tailscale
    uv
    cmake
    ninja
    clang_17
    numactl
    openmpi
    gh
    radicle-node
    claude-code
  ];
}
