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
          "The only way to do great work is to love what you do. - Steve Jobs"
          "Innovation distinguishes between a leader and a follower. - Steve Jobs"  
          "Stay hungry. Stay foolish. - Steve Jobs"
          "Think different. - Apple Inc."
          "Code is poetry. - WordPress"
          "Simplicity is the ultimate sophistication. - Leonardo da Vinci"
          "Make it work, make it right, make it fast. - Kent Beck"
          "Premature optimization is the root of all evil. - Donald Knuth"
          "Talk is cheap. Show me the code. - Linus Torvalds"
          "Any fool can write code that a computer can understand. Good programmers write code that humans can understand. - Martin Fowler"
        ]
        
        $quotes | get (random int 0..(($quotes | length) - 1))
      }
      
      print (welcome_message)
    '';
    shellAliases = {
      ll = "ls -alh";
      dr = "home-manager switch --flake .#quietbox";
      cat = "bat";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      q = "exit";
      x = "exit";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Ludwig Austermann";
    userEmail = "gogopex@gmail.com";
  };
  
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  
  home.sessionVariables = {
    EDITOR = "hx";
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
  ];
}
