-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
vim.g.zig_fmt_autosave = 0

-- disable relative line numbers, keep absolute
vim.opt.relativenumber = false
vim.opt.number = true

-- disable icons globally
vim.g.have_nerd_font = false
