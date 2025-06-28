-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "v", "i", "x" }, "<left>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<right>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<up>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "n", "v", "i", "x" }, "<down>", '<cmd>echo "Use vim motion !"<CR>')
vim.keymap.set({ "v", "x" }, "<leader>cn", ":CarbonNow<CR>", { desc = "Capture Code snippet", silent = true })
vim.keymap.set("n", "zz", function()
  vim.cmd("q")
end, { desc = "Quit shortcut" })

vim.keymap.set("n", "<leader>pp", function()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    file_path = "[No file opened]"
  end
  print(file_path)
  vim.fn.setreg("+", file_path)
end, { desc = "Show and copy current file path" })

vim.keymap.set("n", "<leader>fx", function()
  local file_path = vim.fn.expand("%:p") -- Full path of current buffer
  if file_path == "" then
    vim.notify("[No file opened]", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("chmod +x " .. vim.fn.shellescape(file_path))
  vim.notify("Made " .. file_path .. " executable", vim.log.levels.INFO)
end, { desc = "Make [F]ile e[X]ecutable (chmod +x)" })
