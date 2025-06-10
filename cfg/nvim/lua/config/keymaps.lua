-- Navigation and view centering
-- vim.keymap.set("n", "<C-Up>", "<C-k>zz", { desc = "Half page up" })
-- vim.keymap.set("n", "<C-Down>", "<C-j>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-j>", "<C-d>zz", { desc = "Half screen down" })
vim.keymap.set("n", "<C-k>", "<C-u>zz", { desc = "Half screen up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Clipboard operations
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>d", [["_d]], { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Line manipulation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
-- vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Navigation shortcuts
vim.keymap.set({ "n", "v" }, "gh", "0", { desc = "Go to start of line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

-- Window navigation
vim.keymap.set("n", "<Alt-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<Alt-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<Alt-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<Alt-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Indentation in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- UI toggles
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting" })
vim.keymap.set("n", "<leader>ux", function()
  local cmp_enabled = vim.g.cmp_enabled or true
  vim.g.cmp_enabled = not cmp_enabled
  if vim.g.cmp_enabled then
    vim.notify("Autocompletion enabled")
  else
    vim.notify("Autocompletion disabled")
  end
end, { desc = "Toggle autocompletion" })
