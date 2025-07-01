{ config, lib, pkgs, ... }:

{
  home-manager.sharedModules = [{
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      
      extraConfig = ''
        set number
        set relativenumber
        set expandtab
        set tabstop=2
        set shiftwidth=2
        set smartindent
        set wrap
        set ignorecase
        set smartcase
        set hlsearch
        set incsearch
        set termguicolors
        set scrolloff=8
        set signcolumn=yes
        set updatetime=50
        set colorcolumn=80
        
        " Leader key
        let mapleader = " "
        
        " Better navigation
        nnoremap <C-d> <C-d>zz
        nnoremap <C-u> <C-u>zz
        nnoremap n nzzzv
        nnoremap N Nzzzv
        
        " System clipboard
        nnoremap <leader>y "+y
        vnoremap <leader>y "+y
        nnoremap <leader>Y "+Y
        
        " Replace word under cursor
        nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
      '';
      
      plugins = with pkgs.vimPlugins; [
        vim-sensible
        vim-commentary
        vim-surround
        vim-fugitive
        nvim-treesitter.withAllGrammars
        telescope-nvim
        plenary-nvim
        gruvbox-material
      ];
      
      extraLuaConfig = ''
        -- Set colorscheme
        vim.cmd[[colorscheme gruvbox-material]]
        
        -- Telescope keybindings
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      '';
    };
  }];
}