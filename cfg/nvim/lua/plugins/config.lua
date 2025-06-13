return {
  -- disabled
  { "saghen/blink.cmp", enabled = false },
  { "saghen/blink.compat", enabled = false },

  { "rcarriga/nvim-notify", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "saghen/blink.cmp", enabled = false },

  -- themes
  { "ellisonleao/gruvbox.nvim" },
  { "aditya-azad/candle-grey" },
  { "huyvohcmc/atlas.vim" },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "candle-grey",
      -- colorscheme = "elflord",
      colorscheme = "gruvbox",
      -- diagnostic = {
      --   signs = true,
      -- },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1000
    end,
    opts = {},
    -- opts = { icons = false },
    -- enabled = false
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      mappings = {
        ask = "<leader>ua",
        edit = "<leader>ue",
        refresh = "<leader>ur",
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",

      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required to true for Windows users
            use_absolute_path = false,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      -- "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = true,
  },

  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Open Oil file explorer" },
    },
    opts = {
      columns = { "icon", "permissions", "size" },
      keymaps = {
        ["<leader>e"] = "actions.close",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { 
        icons_enabled = false,
        theme = "gruvbox",
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{ 'filename', path = 1 }}, -- full file path
        lualine_x = {{ 'diagnostics', sources = {'nvim_lsp'} }},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>g", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = true,
  },
}
