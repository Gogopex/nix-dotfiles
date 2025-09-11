{ config, pkgs, lib, inputs, ... }:

{
  programs.home-manager.enable = true;
  programs.helix = import ../../modules/common/helix-config.nix;
  
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
      }
      
      def welcome_message [] {
        let quotes = [
          "I can't put down the chips"
          "What is impossible for you is not impossible for me."  
          "Ah, Stil, I live in an apocalyptic dream. My steps fit into it so precisely that I fear most of all I will grow bored reliving the thing so exactly."
          "Do not compete with what is happening. To compete is to prepare for failure. Do not be trapped by the need to achieve anything. This way, you achieve everything."
          "Greatness is a transitory experience. It is never consistent. It depends in part upon the myth-making imagination of humankind. The person who experiences greatness must have a feeling for the myth he is in. He must reflect what is projected upon him. And he must have a strong sense of the sardonic. This is what uncouples him from belief in his own pretensions. The sardonic is all that permits him to move within himself. Without this quality, even occasional greatness will destroy a man."
        ]
        
        $quotes | get (random int 0..(($quotes | length) - 1))
      }
      
      print (welcome_message)
    '';
    shellAliases = {
      dr = "home-manager switch --flake .#quietbox --extra-experimental-features 'nix-command flakes pipe-operators'";
      cat = "bat";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Ludwig Pouey";
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
      # If running interactively and nu exists, exec into it
      if [[ $- == *i* ]] && [ -z "$IN_NUSHELL" ] && command -v nu &> /dev/null; then
        export IN_NUSHELL=1
        exec nu
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
  ];
}
