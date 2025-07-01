{ config, lib, pkgs, nixvim, ... }:

{
  home-manager.sharedModules = [{
    imports = [ nixvim.homeManagerModules.nixvim ];
    
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      
      globals.mapleader = " ";
      
      opts = {
        number = true;
        relativenumber = true;
        
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        
        wrap = true;
        ignorecase = true;
        smartcase = true;
        
        hlsearch = true;
        incsearch = true;
        
        termguicolors = true;
        scrolloff = 8;
        signcolumn = "yes";
        updatetime = 50;
        colorcolumn = "80";
      };
      
      colorschemes.gruvbox = {
        enable = true;
        settings = {
          background = "dark";
        };
      };
      
      plugins = {
        comment.enable = true;
        fugitive.enable = true;
        web-devicons.enable = false;
        
        # File explorer
        oil = {
          enable = true;
          settings = {
            view_options.show_hidden = true;
          };
        };
        
        # Treesitter
        treesitter = {
          enable = true;
          settings = {
            ensure_installed = "all";
            highlight.enable = true;
            indent.enable = true;
          };
        };
        
        # Telescope with fzf
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
          };
          extensions = {
            fzf-native = {
              enable = true;
            };
          };
        };
        
        # Debug Adapter Protocol
        dap = {
          enable = true;
          extensions = {
            dap-ui.enable = true;
            dap-virtual-text.enable = true;
          };
        };
        
        # Utility plugins
        lastplace.enable = true;
        sleuth.enable = true;
        
        # Git integration
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
          };
        };
        
        # Visual enhancements
        indent-blankline = {
          enable = true;
          settings = {
            indent.char = "│";
            scope = {
              enabled = true;
              show_start = true;
            };
          };
        };
        
        # Text manipulation
        nvim-surround.enable = true;
        
        # Rust crate version hints
        crates-nvim.enable = true;
        
        # GitHub Copilot
        # Temporarily disabled due to unfree license issue
        # copilot-vim = {
        #   enable = true;
        #   settings = {
        #     filetypes = {
        #       "*" = true;
        #     };
        #   };
        # };
      };
      
      keymaps = [
        {
          mode = "n";
          key = "<C-d>";
          action = "<C-d>zz";
        }
        {
          mode = "n";
          key = "<C-u>";
          action = "<C-u>zz";
        }
        {
          mode = "n";
          key = "n";
          action = "nzzzv";
        }
        {
          mode = "n";
          key = "N";
          action = "Nzzzv";
        }
        {
          mode = "n";
          key = "<leader>y";
          action = "\"+y";
        }
        {
          mode = "v";
          key = "<leader>y";
          action = "\"+y";
        }
        {
          mode = "n";
          key = "<leader>Y";
          action = "\"+Y";
        }
        {
          mode = "n";
          key = "<leader>s";
          action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
        }
        # Oil.nvim keybinding
        {
          mode = "n";
          key = "-";
          action = "<cmd>Oil<CR>";
          options.desc = "Open parent directory";
        }
      ];
      
      # Extra plugins not directly supported by NixVim
      extraPlugins = with pkgs.vimPlugins; [
        # Startup screen
        alpha-nvim
        
        # Git conflict resolution
        git-conflict-nvim
        
        # Multiple cursors
        multicursor-nvim
        
        # File path in statusline
        fileline-nvim
        
        # Code outline
        # Temporarily disabled - norg provider issue
        # (pkgs.vimUtils.buildVimPlugin {
        #   name = "outline.nvim";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "hedyhli";
        #     repo = "outline.nvim";
        #     rev = "main";
        #     sha256 = "0hkjnls9lfrb2k6dngdjxp65khwbd91nmq67h0fh8a0fv6p7d5nm";
        #   };
        # })
        
        # Claude AI integration
        (pkgs.vimUtils.buildVimPlugin {
          name = "claude-code.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "greggh";
            repo = "claude-code.nvim";
            rev = "main";
            sha256 = "14n96zq8yldzqf74rj52gz95n20ig1dk02n20rsjd7vraggad9cc";
          };
        })
      ];
      
      # Configuration for extra plugins
      extraConfigLua = ''
        -- Alpha startup screen
        require('alpha').setup(require('alpha.themes.dashboard').config)
        
        -- Git conflict
        require('git-conflict').setup()
        
        -- Multicursor
        require('multicursor').setup()
        
        -- Outline
        -- Temporarily disabled - norg provider issue
        -- require('outline').setup({
        --   outline_window = {
        --     position = 'right',
        --     width = 25,
        --   },
        -- })
        
        -- Fileline
        require('fileline').setup()
      '';
    };
  }];
}