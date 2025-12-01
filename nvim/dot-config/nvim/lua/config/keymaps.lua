local map = vim.keymap.set

map("n", "zz", function()
  vim.cmd("qa")
end, { desc = "[Q]uit" })

map("n", "<leader>li", function()
  vim.cmd("Lazy")
end, { desc = "[l]azy [I]nfo" })

map("n", "<leader>bb", function()
  vim.cmd("b#")
end, { desc = "Recent buffer" })

map("n", "<leader>li", function()
  vim.cmd("Lazy")
end, { desc = "[l]azy [I]nfo" })

map("n", "<leader>so", function()
  vim.cmd("update")
  vim.cmd("source")
  vim.notify("config re-loaded")
end, { desc = "s[o]urce config" })

map("t", "<esc>", "<c-\\><c-n>")

map({ "t", "i" }, "<a-h>", "<c-\\><c-n><c-w>h")

map({ "t", "i" }, "<a-j>", "<c-\\><c-n><c-w>j")

map({ "t", "i" }, "<a-k>", "<c-\\><c-n><c-w>k")

map({ "t", "i" }, "<a-l>", "<c-\\><c-n><c-w>l")

map({ "n" }, "<a-h>", "<c-w>h")

map({ "n" }, "<a-j>", "<c-w>j")

map({ "n" }, "<a-k>", "<c-w>k")

map({ "n" }, "<a-l>", "<c-w>l")
-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- line mouvement
map({ "n" }, "<c-n>h", "0")
map({ "n" }, "<c-n>l", "$")
-- save file
local formated_diagnostics = function()
  local diagnostic_format = function(diagnostic)
    return string.format("%s [%s]", diagnostic.message, diagnostic.source or "unknown source")
  end
  vim.diagnostic.open_float(nil, {
    format = diagnostic_format,
  })
end

map("n", "<leader>od", formated_diagnostics, { desc = "[O]pen [D]iagnostics" })

map("n", "<leader>nd", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "[N]ext [D]iagnostics" })

map("n", "<leader>pd", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "[P]rev [D]iagnostics" })

map("n", "<leader>pp", function()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    file_path = "[No file opened]"
  end
  vim.notify(file_path)
  vim.fn.setreg("+", file_path)
end, { desc = "Show and copy current file path" })

map("n", "<leader>fx", function()
  local file_path = vim.fn.expand("%:p") -- Full path of current buffer
  if file_path == "" then
    vim.notify("[No file opened]", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("chmod +x " .. vim.fn.shellescape(file_path))
  vim.notify("Made " .. file_path .. " executable", vim.log.levels.INFO)
end, { desc = "Make [F]ile e[X]ecutable (chmod +x)" })
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("w")
  vim.notify("File Saved")
end, { desc = "Save File" })

map("n", "<C-W>f", "<C-W>_", { desc = "Window Full hight", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>wq", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "dD", "d0", { desc = "Delete to start of line", remap = true })
