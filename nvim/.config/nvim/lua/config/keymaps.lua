-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "%", "ggVG", { noremap = true, silent = true, desc = "Select all text" })
vim.keymap.set("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", {
  desc = "Search and replace word under cursor",
})
