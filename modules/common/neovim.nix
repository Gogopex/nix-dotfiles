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
        background = "dark";
      };
      
      colorschemes.gruvbox.enable = true;
      
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
        dap.enable = true;
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
        
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
        crates.enable = true;
        
        # Key bindings helper
        which-key = {
          enable = true;
          settings = {
            delay = 0;  # Instant popup
            icons = {
              mappings = false;
            };
          };
        };
        
        # Session management
        persistence = {
          enable = true;
          settings = {
            dir = "~/.local/share/nvim/sessions/";
          };
        };
        
        # Fuzzy finder
        fzf-lua = {
          enable = true;
          keymaps = {
            "<leader>ff" = "files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
            "<leader>fo" = "oldfiles";
            "<leader>fc" = "grep_cword";
            "<leader>fd" = "diagnostics_document";
          };
        };
        
        # LSP configuration
        lsp = {
          enable = true;
          servers = {
            # Nix
            nil_ls.enable = true;
            
            # Rust
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            
            # TypeScript/JavaScript
            ts_ls.enable = true;
            
            # Python
            pyright.enable = true;
            
            # Go
            gopls.enable = true;
            
            # Lua
            lua_ls.enable = true;
          };
        };
        
        # GitHub Copilot
        # Temporarily disabled - need to handle unfree license properly
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
        # Navigation shortcuts
        {
          mode = ["n" "v"];
          key = "gh";
          action = "0";
          options.desc = "Go to start of line";
        }
        {
          mode = ["n" "v"];
          key = "gl";
          action = "$";
          options.desc = "Go to end of line";
        }
        # Clipboard operations
        {
          mode = "x";
          key = "<leader>p";
          action = "\"_dP";
          options.desc = "Paste without yanking";
        }
        {
          mode = ["n" "v"];
          key = "<leader>d";
          action = "\"_d";
          options.desc = "Delete without yanking";
        }
        # Line manipulation
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<CR>gv=gv";
          options.desc = "Move selection down";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<CR>gv=gv";
          options.desc = "Move selection up";
        }
        # Indentation
        {
          mode = "v";
          key = "<";
          action = "<gv";
          options.desc = "Indent left and keep selection";
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
          options.desc = "Indent right and keep selection";
        }
        # Persistence keymaps
        {
          mode = "n";
          key = "<leader>ps";
          action = "<cmd>lua require('persistence').save()<CR>";
          options.desc = "Save session";
        }
        {
          mode = "n";
          key = "<leader>pr";
          action = "<cmd>lua require('persistence').load()<CR>";
          options.desc = "Restore session";
        }
        {
          mode = "n";
          key = "<leader>pl";
          action = "<cmd>lua require('persistence').load({ last = true })<CR>";
          options.desc = "Restore last session";
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
        
        # Yank history management
        yanky-nvim
        
        # Startup time profiling
        vim-startuptime
        
        # Code outline - temporarily disabled due to norg provider issue
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
        
        -- Yanky (yank history)
        require('yanky').setup({
          ring = {
            history_length = 100,
            storage = "shada",
            sync_with_numbered_registers = true,
          },
          picker = {
            select = {
              action = nil, -- default action
            },
          },
          system_clipboard = {
            sync_with_ring = true,
          },
        })
        
        -- Remap for yanky
        vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
        vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
        vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
        vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
        vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
        vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
        vim.keymap.set("n", "<leader>yh", ":YankyRingHistory<CR>", { desc = "Yank history" })
        
        -- Outline - temporarily disabled
        -- require('outline').setup({
        --   outline_window = {
        --     position = 'right',
        --     width = 25,
        --   },
        --   providers = {
        --     priority = { 'lsp', 'markdown', 'man' },  -- Exclude 'norg' provider
        --   },
        -- })
        
        -- Fileline
        require('fileline').setup()
      '';
    };
  }];
}