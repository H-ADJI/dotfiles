-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "v", "i", "x" }, "<left>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<right>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<up>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<down>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "v", "x" }, "<leader>cn", ":CarbonNow<CR>", { desc = "Capture Code snippet", silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>Fp",
  ':let @+ = expand("%:p")<CR>:echo expand("%:p")<CR>',
  { noremap = true, silent = true, desc = "Copy Buffer Full Path" }
)
