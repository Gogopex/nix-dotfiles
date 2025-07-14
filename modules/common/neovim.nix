{
  pkgs,
  nixvim,
  lib,
  ...
}:
let
  inherit (lib) mapAttrsToList;
in

{
  home-manager.sharedModules = [
    {
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

          oil = {
            enable = true;
            settings = {
              view_options.show_hidden = true;
              columns = [
                "size"
                "mtime"
              ]; # "icon" for icons
            };
          };

          treesitter = {
            enable = true;
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              c
              cpp
              rust
              zig
              go
              python
              java
              php
              typescript
              javascript
              haskell

              nix
              lua
              bash
              json
              yaml
              toml
              html
              css
              markdown
              markdown_inline
              regex
              vim
              vimdoc
              query
              comment
            ];
            settings = {
              highlight.enable = true;
              indent.enable = true;
              incremental_selection = {
                enable = true;
                keymaps = {
                  init_selection = false;
                  node_incremental = false;
                  scope_incremental = false;
                  node_decremental = false;
                };
              };
            };
          };

          treesitter-textobjects = {
            enable = true;
            select = {
              enable = true;
              keymaps = {
                "af" = "@function.outer";
                "if" = "@function.inner";
                "ac" = "@class.outer";
                "ic" = "@class.inner";
                "ab" = "@block.outer";
                "ib" = "@block.inner";
                "ap" = "@parameter.outer";
                "ip" = "@parameter.inner";
              };
            };
            move = {
              enable = true;
              gotoNextStart = {
                "]f" = "@function.outer";
                "]c" = "@class.outer";
              };
              gotoPreviousStart = {
                "[f" = "@function.outer";
                "[c" = "@class.outer";
              };
            };
          };

          telescope = {
            enable = true;
            settings = {
              defaults = {
                disable_devicons = true;
              };
            };
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

          dap.enable = true;
          dap-ui.enable = true;
          dap-virtual-text.enable = true;

          lastplace.enable = true;
          sleuth.enable = true;

          gitsigns = {
            enable = true;
            settings = {
              current_line_blame = true;
            };
          };

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

          crates.enable = true;

          mini = {
            enable = true;
            modules = {
              surround = {
                mappings = {
                  add = "sa";
                  delete = "sd";
                  find = "sf";
                  find_left = "sF";
                  highlight = "sh";
                  replace = "sr";
                  update_n_lines = "sn";
                };
              };
              pairs = {
                modes = {
                  insert = true;
                  command = true;
                  terminal = false;
                };
              };
              move = {
                mappings = {
                  left = "<M-h>";
                  right = "<M-l>";
                  down = "<M-j>";
                  up = "<M-k>";
                  line_left = "<M-h>";
                  line_right = "<M-l>";
                  line_down = "<M-j>";
                  line_up = "<M-k>";
                };
              };
              align = { };
              bracketed = { };
              clue = {
                triggers = [
                  {
                    mode = "n";
                    keys = "<Leader>";
                  }
                  {
                    mode = "x";
                    keys = "<Leader>";
                  }
                  {
                    mode = "i";
                    keys = "<C-x>";
                  }
                  {
                    mode = "n";
                    keys = "g";
                  }
                  {
                    mode = "x";
                    keys = "g";
                  }
                  {
                    mode = "n";
                    keys = "'";
                  }
                  {
                    mode = "n";
                    keys = "`";
                  }
                  {
                    mode = "x";
                    keys = "'";
                  }
                  {
                    mode = "x";
                    keys = "`";
                  }
                  {
                    mode = "n";
                    keys = "\"";
                  }
                  {
                    mode = "x";
                    keys = "\"";
                  }
                  {
                    mode = "n";
                    keys = "<C-w>";
                  }
                  {
                    mode = "n";
                    keys = "z";
                  }
                  {
                    mode = "x";
                    keys = "z";
                  }
                  {
                    mode = "n";
                    keys = "[";
                  }
                  {
                    mode = "n";
                    keys = "]";
                  }
                  {
                    mode = "n";
                    keys = "s";
                  }
                ];
                clues = [
                  {
                    mode = "n";
                    keys = "<Leader>a";
                    desc = "+AI/Claude";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>b";
                    desc = "+Buffers";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>c";
                    desc = "+Code/LSP";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>C";
                    desc = "+Crates";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>d";
                    desc = "+Debug";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>f";
                    desc = "+Find/Files";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>g";
                    desc = "+Git";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>gh";
                    desc = "+Hunks";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>gc";
                    desc = "+Conflicts";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>p";
                    desc = "+Persistence";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>q";
                    desc = "+Quit/Session";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>s";
                    desc = "+Search";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>u";
                    desc = "+UI/Toggle";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>w";
                    desc = "+Windows";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>x";
                    desc = "+Diagnostics";
                  }
                  {
                    mode = "n";
                    keys = "<Leader>y";
                    desc = "+Yank";
                  }
                  {
                    mode = "n";
                    keys = "<Leader><tab>";
                    desc = "+Tabs";
                  }
                ];
                window = {
                  delay = 0;
                  config = {
                    width = "auto";
                  };
                };
              };
            };
          };

          persistence = {
            enable = true;
            settings = {
              dir = "~/.local/share/nvim/sessions/";
            };
          };

          lsp = {
            enable = true;
            servers = {
              nixd.enable = true;
              rust_analyzer = {
                enable = true;
                installCargo = false;
                installRustc = false;
              };
              ts_ls.enable = true;
              pyright.enable = true;
              gopls.enable = true;
              lua_ls.enable = true;
              clangd.enable = true;
              zls.enable = true;
              jdtls.enable = true;
              phpactor.enable = true;
              hls = {
                enable = true;
                installGhc = false;
              };
            };
          };

          # GitHub Copilot
          # temporarily disabled - need to handle unfree license properly
          # copilot-vim = {
          #   enable = true;
          #   settings = {
          #     filetypes = {
          #       "*" = true;
          #     };
          #   };
          # };
        };

        keymaps =
          [
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
              mode = [
                "n"
                "v"
              ];
              key = "gh";
              action = "0";
              options.desc = "Go to start of line";
            }
            {
              mode = [
                "n"
                "v"
              ];
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
              mode = [
                "n"
                "v"
              ];
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
            {
              mode = [
                "n"
                "v"
              ];
              key = "<C-k>";
              action = "<cmd>lua require('nvim-treesitter.incremental_selection').node_incremental()<CR>";
              options.desc = "Expand selection";
            }
            {
              mode = [
                "n"
                "v"
              ];
              key = "<C-j>";
              action = "<cmd>lua require('nvim-treesitter.incremental_selection').node_decremental()<CR>";
              options.desc = "Shrink selection";
            }
            {
              mode = "n";
              key = "C";
              action = "\"_c$";
              options.desc = "Change to line end";
            }
            {
              mode = "n";
              key = "D";
              action = "\"_d$";
              options.desc = "Delete to line end";
            }
            {
              mode = "n";
              key = "Y";
              action = "y$";
              options.desc = "Yank to line end";
            }
            {
              mode = "n";
              key = "S";
              action = "yss";
              options = {
                desc = "Surround line";
                remap = true;
              };
            }
            # Multi-line Operations
            {
              mode = "n";
              key = "dj";
              action = "Vjd";
              options.desc = "Delete current and next line";
            }
            {
              mode = "n";
              key = "dk";
              action = "Vkd";
              options.desc = "Delete current and previous line";
            }
            {
              mode = "n";
              key = "yj";
              action = "Vjy";
              options.desc = "Yank current and next line";
            }
            {
              mode = "n";
              key = "yk";
              action = "Vky";
              options.desc = "Yank current and previous line";
            }
            {
              mode = "n";
              key = "dG";
              action = "VGd";
              options.desc = "Delete to end of file";
            }
            {
              mode = "n";
              key = "yG";
              action = "VGy";
              options.desc = "Yank to end of file";
            }
            {
              mode = "n";
              key = "dgg";
              action = "VggOd";
              options.desc = "Delete to beginning of file";
            }
            {
              mode = "n";
              key = "ygg";
              action = "VggOy";
              options.desc = "Yank to beginning of file";
            }
            # Word Operations with clipboard
            {
              mode = "n";
              key = "dw";
              action = "\"_dw";
              options.desc = "Delete word";
            }
            {
              mode = "n";
              key = "dW";
              action = "\"_dW";
              options.desc = "Delete WORD";
            }
            {
              mode = "n";
              key = "yw";
              action = "yw";
              options.desc = "Yank word";
            }
            {
              mode = "n";
              key = "yW";
              action = "yW";
              options.desc = "Yank WORD";
            }
            # Search improvements for visual mode
            {
              mode = "v";
              key = "*";
              action = "y/\\V<C-R>=escape(@\", '/\\')<CR><CR>";
              options.desc = "Search forward for selection";
            }
            {
              mode = "v";
              key = "#";
              action = "y?\\V<C-R>=escape(@\", '?\\')<CR><CR>";
              options.desc = "Search backward for selection";
            }
            # Visual mode operations
            {
              mode = "v";
              key = "d";
              action = "\"_d";
              options.desc = "Delete without yanking";
            }
            {
              mode = "v";
              key = "c";
              action = "\"_c";
              options.desc = "Change without yanking";
            }
            {
              mode = "v";
              key = "p";
              action = "\"_dP";
              options.desc = "Paste without yanking";
            }
            # Manual completion trigger
            {
              mode = "i";
              key = "<C-space>";
              action = "<C-n>";
              options.desc = "Trigger completion";
            }
            # Claude Code keymaps
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = "<leader>a${key}";
                action = "<cmd>${action}<cr>";
                options.desc = desc;
              }
            )
            {
              c = {
                action = "ClaudeCode";
                desc = "Toggle Claude";
              };
              f = {
                action = "ClaudeCodeFocus";
                desc = "Focus Claude";
              };
              r = {
                action = "ClaudeCode --resume";
                desc = "Resume Claude";
              };
              C = {
                action = "ClaudeCode --continue";
                desc = "Continue Claude";
              };
              b = {
                action = "ClaudeCodeAdd %";
                desc = "Add current buffer to Claude";
              };
              a = {
                action = "ClaudeCodeDiffAccept";
                desc = "Accept Claude diff";
              };
              d = {
                action = "ClaudeCodeDiffDeny";
                desc = "Deny Claude diff";
              };
            }
          )
          ++ [
            {
              mode = "v";
              key = "<leader>as";
              action = "<cmd>ClaudeCodeSend<cr>";
              options.desc = "Send selection to Claude";
            }

            # LazyVim-style keybindings
            # General Navigation & Editing
            {
              mode = [
                "i"
                "x"
                "n"
                "s"
              ];
              key = "<C-s>";
              action = "<cmd>w<cr><esc>";
              options.desc = "Save file";
            }
            {
              mode = "n";
              key = "<Esc><Esc>";
              action = "<cmd>nohlsearch<CR>";
              options.desc = "Clear search highlight";
            }
            {
              mode = "n";
              key = "<leader>fn";
              action = "<cmd>enew<cr>";
              options.desc = "New file";
            }
            {
              mode = "n";
              key = "[b";
              action = "<cmd>bprevious<cr>";
              options.desc = "Previous buffer";
            }
            {
              mode = "n";
              key = "]b";
              action = "<cmd>bnext<cr>";
              options.desc = "Next buffer";
            }

            # Window Management
            {
              mode = "n";
              key = "<leader>ww";
              action = "<C-W>p";
              options.desc = "Other window";
            }
            {
              mode = "n";
              key = "<leader>wd";
              action = "<C-W>c";
              options.desc = "Delete window";
            }
            {
              mode = "n";
              key = "<leader>w-";
              action = "<C-W>s";
              options.desc = "Split window below";
            }
            {
              mode = "n";
              key = "<leader>w|";
              action = "<C-W>v";
              options.desc = "Split window right";
            }
            {
              mode = "n";
              key = "<leader>-";
              action = "<C-W>s";
              options.desc = "Split window below";
            }
            {
              mode = "n";
              key = "<leader>|";
              action = "<C-W>v";
              options.desc = "Split window right";
            }

            # Buffer Management
            {
              mode = "n";
              key = "<leader>bb";
              action = "<cmd>e #<cr>";
              options.desc = "Switch to other buffer";
            }
            {
              mode = "n";
              key = "<leader>bd";
              action = "<cmd>bdelete<cr>";
              options.desc = "Delete buffer";
            }
            {
              mode = "n";
              key = "<leader>bD";
              action = "<cmd>bdelete!<cr>";
              options.desc = "Delete buffer (force)";
            }
            {
              mode = "n";
              key = "<leader>bo";
              action = "<cmd>%bdelete|edit#|bdelete#<cr>";
              options.desc = "Delete other buffers";
            }

            # Search (Telescope)
            {
              mode = "n";
              key = "<leader><space>";
              action = "<cmd>Telescope find_files<cr>";
              options.desc = "Find files";
            }
            {
              mode = "n";
              key = "<leader>,";
              action = "<cmd>Telescope buffers show_all_buffers=true<cr>";
              options.desc = "Switch buffer";
            }
            {
              mode = "n";
              key = "<leader>/";
              action = "<cmd>Telescope live_grep<cr>";
              options.desc = "Grep";
            }
            {
              mode = "n";
              key = "<leader>:";
              action = "<cmd>Telescope command_history<cr>";
              options.desc = "Command history";
            }
            {
              mode = "n";
              key = "<leader>fr";
              action = "<cmd>Telescope oldfiles<cr>";
              options.desc = "Recent files";
            }
            {
              mode = "n";
              key = "<leader>sg";
              action = "<cmd>Telescope live_grep<cr>";
              options.desc = "Grep";
            }
            {
              mode = "n";
              key = "<leader>sw";
              action = "<cmd>Telescope grep_string<cr>";
              options.desc = "Search word";
            }
            {
              mode = "v";
              key = "<leader>sw";
              action = "<cmd>Telescope grep_string<cr>";
              options.desc = "Search selection";
            }
            {
              mode = "n";
              key = "<leader>sW";
              action = "<cmd>Telescope grep_string word_match=-w<cr>";
              options.desc = "Search word (whole)";
            }
            {
              mode = "n";
              key = "<leader>sh";
              action = "<cmd>Telescope help_tags<cr>";
              options.desc = "Help pages";
            }
            {
              mode = "n";
              key = "<leader>sk";
              action = "<cmd>Telescope keymaps<cr>";
              options.desc = "Keymaps";
            }
            {
              mode = "n";
              key = "<leader>ss";
              action = "<cmd>Telescope builtin<cr>";
              options.desc = "Select Telescope";
            }
            {
              mode = "n";
              key = "<leader>so";
              action = "<cmd>Telescope vim_options<cr>";
              options.desc = "Vim options";
            }
            {
              mode = "n";
              key = "<leader>sR";
              action = "<cmd>Telescope resume<cr>";
              options.desc = "Resume search";
            }
            {
              mode = "n";
              key = "<leader>sd";
              action = "<cmd>Telescope diagnostics bufnr=0<cr>";
              options.desc = "Document diagnostics";
            }
            {
              mode = "n";
              key = "<leader>sD";
              action = "<cmd>Telescope diagnostics<cr>";
              options.desc = "Workspace diagnostics";
            }

            # Git (Gitsigns)
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = key;
                action = "<cmd>Gitsigns ${action}<cr>";
                options.desc = desc;
              }
            )
            {
              "]h" = {
                action = "next_hunk";
                desc = "Next hunk";
              };
              "[h" = {
                action = "prev_hunk";
                desc = "Previous hunk";
              };
            }
          )
          ++ [
            {
              mode = [
                "n"
                "v"
              ];
              key = "<leader>ghs";
              action = "<cmd>Gitsigns stage_hunk<cr>";
              options.desc = "Stage hunk";
            }
            {
              mode = [
                "n"
                "v"
              ];
              key = "<leader>ghr";
              action = "<cmd>Gitsigns reset_hunk<cr>";
              options.desc = "Reset hunk";
            }
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = "<leader>gh${key}";
                action = action;
                options.desc = desc;
              }
            )
            {
              S = {
                action = "<cmd>Gitsigns stage_buffer<cr>";
                desc = "Stage buffer";
              };
              u = {
                action = "<cmd>Gitsigns undo_stage_hunk<cr>";
                desc = "Undo stage hunk";
              };
              R = {
                action = "<cmd>Gitsigns reset_buffer<cr>";
                desc = "Reset buffer";
              };
              p = {
                action = "<cmd>Gitsigns preview_hunk<cr>";
                desc = "Preview hunk";
              };
              b = {
                action = "<cmd>lua require('gitsigns').blame_line{full=true}<cr>";
                desc = "Blame line";
              };
              d = {
                action = "<cmd>Gitsigns diffthis<cr>";
                desc = "Diff this";
              };
              D = {
                action = "<cmd>lua require('gitsigns').diffthis('~')<cr>";
                desc = "Diff this ~";
              };
            }
          )
          ++ [

            # Git (Fugitive)
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = "<leader>g${key}";
                action = "<cmd>Git ${action}<cr>";
                options.desc = desc;
              }
            )
            {
              s = {
                action = "";
                desc = "Git status";
              };
              c = {
                action = "commit";
                desc = "Git commit";
              };
              p = {
                action = "push";
                desc = "Git push";
              };
              P = {
                action = "pull";
                desc = "Git pull";
              };
              b = {
                action = "blame";
                desc = "Git blame";
              };
            }
          )
          ++ [

            # LSP
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = key;
                action = action;
                options.desc = desc;
              }
            )
            {
              gd = {
                action = "<cmd>lua vim.lsp.buf.definition()<cr>";
                desc = "Go to definition";
              };
              gr = {
                action = "<cmd>Telescope lsp_references<cr>";
                desc = "References";
              };
              gI = {
                action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
                desc = "Go to implementation";
              };
              gy = {
                action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
                desc = "Go to type definition";
              };
              gD = {
                action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
                desc = "Go to declaration";
              };
              K = {
                action = "<cmd>lua vim.lsp.buf.hover()<cr>";
                desc = "Hover";
              };
              gK = {
                action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
                desc = "Signature help";
              };
            }
          )
          ++ [
            {
              mode = [
                "n"
                "v"
              ];
              key = "<leader>ca";
              action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
              options.desc = "Code action";
            }
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = "<leader>c${key}";
                action = "<cmd>${action}<cr>";
                options.desc = desc;
              }
            )
            {
              c = {
                action = "lua vim.lsp.codelens.run()";
                desc = "Run codelens";
              };
              C = {
                action = "lua vim.lsp.codelens.refresh()";
                desc = "Refresh codelens";
              };
              r = {
                action = "lua vim.lsp.buf.rename()";
                desc = "Rename";
              };
              d = {
                action = "lua vim.diagnostic.open_float()";
                desc = "Line diagnostics";
              };
            }
          )
          ++ [
            {
              mode = [
                "n"
                "v"
              ];
              key = "<leader>cf";
              action = "<cmd>lua vim.lsp.buf.format({async = true})<cr>";
              options.desc = "Format";
            }

            # Diagnostic navigation
          ]
          ++ (mapAttrsToList
            (
              key:
              { action, desc }:
              {
                mode = "n";
                key = key;
                action = "<cmd>lua vim.diagnostic.${action}<cr>";
                options.desc = desc;
              }
            )
            {
              "]d" = {
                action = "goto_next()";
                desc = "Next diagnostic";
              };
              "[d" = {
                action = "goto_prev()";
                desc = "Previous diagnostic";
              };
              "]e" = {
                action = "goto_next({severity = vim.diagnostic.severity.ERROR})";
                desc = "Next error";
              };
              "[e" = {
                action = "goto_prev({severity = vim.diagnostic.severity.ERROR})";
                desc = "Previous error";
              };
              "]w" = {
                action = "goto_next({severity = vim.diagnostic.severity.WARN})";
                desc = "Next warning";
              };
              "[w" = {
                action = "goto_prev({severity = vim.diagnostic.severity.WARN})";
                desc = "Previous warning";
              };
            }
          )
          ++ [

            # Debug (DAP)
            {
              mode = "n";
              key = "<leader>db";
              action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
              options.desc = "Toggle breakpoint";
            }
            {
              mode = "n";
              key = "<leader>dB";
              action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
              options.desc = "Breakpoint condition";
            }
            {
              mode = "n";
              key = "<leader>dc";
              action = "<cmd>lua require('dap').continue()<cr>";
              options.desc = "Continue";
            }
            {
              mode = "n";
              key = "<leader>dC";
              action = "<cmd>lua require('dap').run_to_cursor()<cr>";
              options.desc = "Run to cursor";
            }
            {
              mode = "n";
              key = "<leader>dg";
              action = "<cmd>lua require('dap').goto_()<cr>";
              options.desc = "Go to line (no execute)";
            }
            {
              mode = "n";
              key = "<leader>di";
              action = "<cmd>lua require('dap').step_into()<cr>";
              options.desc = "Step into";
            }
            {
              mode = "n";
              key = "<leader>dj";
              action = "<cmd>lua require('dap').down()<cr>";
              options.desc = "Down";
            }
            {
              mode = "n";
              key = "<leader>dk";
              action = "<cmd>lua require('dap').up()<cr>";
              options.desc = "Up";
            }
            {
              mode = "n";
              key = "<leader>dl";
              action = "<cmd>lua require('dap').run_last()<cr>";
              options.desc = "Run last";
            }
            {
              mode = "n";
              key = "<leader>do";
              action = "<cmd>lua require('dap').step_out()<cr>";
              options.desc = "Step out";
            }
            {
              mode = "n";
              key = "<leader>dO";
              action = "<cmd>lua require('dap').step_over()<cr>";
              options.desc = "Step over";
            }
            {
              mode = "n";
              key = "<leader>dp";
              action = "<cmd>lua require('dap').pause()<cr>";
              options.desc = "Pause";
            }
            {
              mode = "n";
              key = "<leader>dr";
              action = "<cmd>lua require('dap').repl.toggle()<cr>";
              options.desc = "Toggle REPL";
            }
            {
              mode = "n";
              key = "<leader>ds";
              action = "<cmd>lua require('dap').session()<cr>";
              options.desc = "Session";
            }
            {
              mode = "n";
              key = "<leader>dt";
              action = "<cmd>lua require('dap').terminate()<cr>";
              options.desc = "Terminate";
            }
            {
              mode = "n";
              key = "<leader>dw";
              action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
              options.desc = "Widgets";
            }

            # Toggle Options
            {
              mode = "n";
              key = "<leader>uf";
              action = "<cmd>lua vim.g.autoformat = not vim.g.autoformat; print('Autoformat: ' .. tostring(vim.g.autoformat))<cr>";
              options.desc = "Toggle autoformat (global)";
            }
            {
              mode = "n";
              key = "<leader>us";
              action = "<cmd>setlocal spell!<cr>";
              options.desc = "Toggle spelling";
            }
            {
              mode = "n";
              key = "<leader>uw";
              action = "<cmd>setlocal wrap!<cr>";
              options.desc = "Toggle word wrap";
            }
            {
              mode = "n";
              key = "<leader>uL";
              action = "<cmd>setlocal relativenumber!<cr>";
              options.desc = "Toggle relative numbers";
            }
            {
              mode = "n";
              key = "<leader>ul";
              action = "<cmd>setlocal number!<cr>";
              options.desc = "Toggle line numbers";
            }
            {
              mode = "n";
              key = "<leader>ud";
              action = "<cmd>lua vim.diagnostic.disable(not vim.diagnostic.is_disabled())<cr>";
              options.desc = "Toggle diagnostics";
            }
            {
              mode = "n";
              key = "<leader>uc";
              action = "<cmd>setlocal conceallevel=0 conceallevel?<cr>";
              options.desc = "Toggle conceal";
            }
            {
              mode = "n";
              key = "<leader>uh";
              action = "<cmd>set hlsearch!<cr>";
              options.desc = "Toggle hlsearch";
            }
            {
              mode = "n";
              key = "<leader>ui";
              action = "<cmd>lua require('indent_blankline').toggle()<cr>";
              options.desc = "Toggle indent guides";
            }
            {
              mode = "n";
              key = "<leader>ut";
              action = "<cmd>TSToggle highlight<cr>";
              options.desc = "Toggle treesitter highlight";
            }

            # Session (Persistence)
            {
              mode = "n";
              key = "<leader>qs";
              action = "<cmd>lua require('persistence').select()<cr>";
              options.desc = "Select session";
            }
            {
              mode = "n";
              key = "<leader>ql";
              action = "<cmd>lua require('persistence').load({ last = true })<cr>";
              options.desc = "Restore last session";
            }
            {
              mode = "n";
              key = "<leader>qd";
              action = "<cmd>lua require('persistence').stop()<cr>";
              options.desc = "Don't save session";
            }

            # Quit
            {
              mode = "n";
              key = "<leader>qq";
              action = "<cmd>qa<cr>";
              options.desc = "Quit all";
            }
            {
              mode = "n";
              key = "<leader>q!";
              action = "<cmd>qa!<cr>";
              options.desc = "Quit all (force)";
            }

            # UI/Diagnostics
            {
              mode = "n";
              key = "<leader>un";
              action = "<cmd>lua vim.notify.dismiss({ silent = true, pending = true })<cr>";
              options.desc = "Dismiss notifications";
            }
            {
              mode = "n";
              key = "<leader>xl";
              action = "<cmd>lopen<cr>";
              options.desc = "Location list";
            }
            {
              mode = "n";
              key = "<leader>xq";
              action = "<cmd>copen<cr>";
              options.desc = "Quickfix list";
            }

            # Tabs
            {
              mode = "n";
              key = "<leader><tab><tab>";
              action = "<cmd>tabnew<cr>";
              options.desc = "New tab";
            }
            {
              mode = "n";
              key = "<leader><tab>]";
              action = "<cmd>tabnext<cr>";
              options.desc = "Next tab";
            }
            {
              mode = "n";
              key = "<leader><tab>[";
              action = "<cmd>tabprevious<cr>";
              options.desc = "Previous tab";
            }
            {
              mode = "n";
              key = "<leader><tab>d";
              action = "<cmd>tabclose<cr>";
              options.desc = "Close tab";
            }
            {
              mode = "n";
              key = "<leader><tab>f";
              action = "<cmd>tabfirst<cr>";
              options.desc = "First tab";
            }
            {
              mode = "n";
              key = "<leader><tab>l";
              action = "<cmd>tablast<cr>";
              options.desc = "Last tab";
            }

            # Helix-style window navigation
            {
              mode = "n";
              key = "<leader>wh";
              action = "<C-W>h";
              options.desc = "Go to left window";
            }
            {
              mode = "n";
              key = "<leader>wj";
              action = "<C-W>j";
              options.desc = "Go to down window";
            }
            {
              mode = "n";
              key = "<leader>wk";
              action = "<C-W>k";
              options.desc = "Go to up window";
            }
            {
              mode = "n";
              key = "<leader>wl";
              action = "<C-W>l";
              options.desc = "Go to right window";
            }

            # Plugin-specific keybindings
            # Oil.nvim
            {
              mode = "n";
              key = "<leader>e";
              action = "<cmd>Oil<cr>";
              options.desc = "Open file explorer";
            }

            # Git-conflict.nvim
            {
              mode = "n";
              key = "<leader>gco";
              action = "<cmd>GitConflictChooseOurs<cr>";
              options.desc = "Choose ours";
            }
            {
              mode = "n";
              key = "<leader>gct";
              action = "<cmd>GitConflictChooseTheirs<cr>";
              options.desc = "Choose theirs";
            }
            {
              mode = "n";
              key = "<leader>gcb";
              action = "<cmd>GitConflictChooseBoth<cr>";
              options.desc = "Choose both";
            }
            {
              mode = "n";
              key = "<leader>gc0";
              action = "<cmd>GitConflictChooseNone<cr>";
              options.desc = "Choose none";
            }
            {
              mode = "n";
              key = "]x";
              action = "<cmd>GitConflictNextConflict<cr>";
              options.desc = "Next conflict";
            }
            {
              mode = "n";
              key = "[x";
              action = "<cmd>GitConflictPrevConflict<cr>";
              options.desc = "Previous conflict";
            }

            # Comment.nvim additional keybindings
            {
              mode = "n";
              key = "<leader>cc";
              action = "gcc";
              options = {
                desc = "Comment line";
                remap = true;
              };
            }
            {
              mode = "v";
              key = "<leader>cc";
              action = "gc";
              options = {
                desc = "Comment selection";
                remap = true;
              };
            }

            # Crates.nvim (Rust) - using <leader>C prefix to avoid conflicts
            {
              mode = "n";
              key = "<leader>Ct";
              action = "<cmd>lua require('crates').toggle()<cr>";
              options.desc = "Toggle crate popup";
            }
            {
              mode = "n";
              key = "<leader>Cr";
              action = "<cmd>lua require('crates').reload()<cr>";
              options.desc = "Reload crate info";
            }
            {
              mode = "n";
              key = "<leader>Cv";
              action = "<cmd>lua require('crates').show_versions_popup()<cr>";
              options.desc = "Show crate versions";
            }
            {
              mode = "n";
              key = "<leader>Cf";
              action = "<cmd>lua require('crates').show_features_popup()<cr>";
              options.desc = "Show crate features";
            }
            {
              mode = "n";
              key = "<leader>Cd";
              action = "<cmd>lua require('crates').show_dependencies_popup()<cr>";
              options.desc = "Show crate dependencies";
            }

            # Additional useful keybindings
            {
              mode = "n";
              key = "<leader>o";
              action = "<cmd>e #<cr>";
              options.desc = "Alternate file";
            }
            {
              mode = "n";
              key = "<C-w>m";
              action = "<cmd>lua vim.cmd('resize') vim.cmd('vertical resize')<cr>";
              options.desc = "Maximize window";
            }
            {
              mode = "n";
              key = "<leader>fm";
              action = "<cmd>lua vim.lsp.buf.format({async = true})<cr>";
              options.desc = "Format buffer";
            }
            {
              mode = "n";
              key = "<leader>rn";
              action = "<cmd>lua vim.lsp.buf.rename()<cr>";
              options.desc = "Smart rename";
            }
          ];

        # Extra plugins not directly supported by NixVim
        extraPlugins = with pkgs.vimPlugins; [
          # Startup screen
          alpha-nvim

          # Git conflict resolution
          git-conflict-nvim

          # Multiple cursors
          (pkgs.vimUtils.buildVimPlugin {
            name = "multicursor.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "jake-stewart";
              repo = "multicursor.nvim";
              rev = "1.0";
              sha256 = "sha256-bCk/b1LKORvgcpQwAGv9foa9fl4TwHN64UEdzlncAi4=";
            };
          })

          # File path in statusline
          (pkgs.vimUtils.buildVimPlugin {
            name = "fileline.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "lewis6991";
              repo = "fileline.nvim";
              rev = "master";
              sha256 = "sha256-Nn7FdhrMYIFrA72lW6fNubsrKss0QfH06oveOgSIHVE=";
            };
          })

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
            name = "claudecode.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "coder";
              repo = "claudecode.nvim";
              rev = "main";
              sha256 = "sha256-h56TYz3SvdYw2R6f+NCtiFk3BRRV1+hOVa+BKjnav8E=";
            };
          })

          # Required dependency for claudecode.nvim
          snacks-nvim
        ];

        # Configuration for extra plugins
        extraConfigLua = ''
          -- Alpha startup screen
          require('alpha').setup(require('alpha.themes.dashboard').config)

          -- Git conflict
          require('git-conflict').setup()

          -- Multicursor
          local mc = require('multicursor-nvim')
          mc.setup()

          -- Multicursor keymaps
          vim.keymap.set("n", "<C-n>", function() mc.addCursor("*") end, { desc = "Add cursor at next match" })
          vim.keymap.set("n", "<C-p>", function() mc.addCursor("#") end, { desc = "Add cursor at previous match" })
          vim.keymap.set("n", "<C-x>", function() mc.skipCursor("*") end, { desc = "Skip current match" })
          vim.keymap.set("n", "<Esc>", function() 
            -- Don't interfere with telescope pickers
            if vim.bo.filetype == "TelescopePrompt" then
              return "<Esc>"
            end
            
            if mc.hasCursors() then
              mc.clearCursors()
            else
              vim.cmd("nohl")
            end
          end, { desc = "Clear cursors/search", expr = true })


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

          require('claudecode').setup({
            port_range = { min = 10000, max = 65535 },
            auto_start = true,
            log_level = "info",
            
            track_selection = true,
            visual_demotion_delay_ms = 50,
            
            terminal = {
              split_side = "right",
            }
          })
        '';
      };
    }
  ];
}
