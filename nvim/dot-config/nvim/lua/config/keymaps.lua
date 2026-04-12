local map = vim.keymap.set

-- save
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("w")
  vim.notify("File Saved")
end, { desc = "Save file" })

map("n", "<leader>rl", function()
  vim.cmd("LspRestart")
end, { desc = "[R]estart [L]SP" })

map("n", "<leader>rb", function()
  vim.cmd("e")
end, { desc = "[R]eload [B]uffer" })

map("n", "zz", function()
  vim.cmd("qa")
end, { desc = "[Q]uit all" })

map("n", "<leader>li", function()
  vim.cmd("Lazy")
end, { desc = "[L]azy [I]nfo" })

map("n", "<leader>bb", function()
  vim.cmd("b#")
end, { desc = "Switch to recent buffer" })

map("n", "<leader>so", function()
  vim.cmd("update")
  vim.cmd("source")
  vim.notify("config re-loaded")
end, { desc = "[S]ource c[O]nfig" })

map("t", "<esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

map({ "t", "i" }, "<a-h>", "<c-\\><c-n><c-w>h", { desc = "Move to left window" })
map({ "t", "i" }, "<a-j>", "<c-\\><c-n><c-w>j", { desc = "Move to lower window" })
map({ "t", "i" }, "<a-k>", "<c-\\><c-n><c-w>k", { desc = "Move to upper window" })
map({ "t", "i" }, "<a-l>", "<c-\\><c-n><c-w>l", { desc = "Move to right window" })

map("n", "<a-h>", "<c-w>h", { desc = "Move to left window" })
map("n", "<a-j>", "<c-w>j", { desc = "Move to lower window" })
map("n", "<a-k>", "<c-w>k", { desc = "Move to upper window" })
map("n", "<a-l>", "<c-w>l", { desc = "Move to right window" })

-- better indenting
map("x", "<", "<gv", { desc = "Indent left and reselect" })
map("x", ">", ">gv", { desc = "Indent right and reselect" })

-- diagnostics
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
end, { desc = "[N]ext [D]iagnostic" })

map("n", "<leader>pd", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "[P]revious [D]iagnostic" })

-- file utils
map("n", "<leader>pp", function()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    file_path = "[No file opened]"
  end
  vim.notify(file_path)
  vim.fn.setreg("+", file_path)
end, { desc = "Copy current file path" })

map("n", "<leader>fx", function()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    vim.notify("[No file opened]", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("chmod +x " .. vim.fn.shellescape(file_path))
  vim.notify("Made " .. file_path .. " executable", vim.log.levels.INFO)
end, { desc = "Make file executable (chmod +x)" })

-- window management
map("n", "<C-W>fh", "<C-W>_", { desc = "Maximize window height", remap = true })
map("n", "<C-W>fw", "<C-W>|", { desc = "Maximize window width", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>wq", "<C-W>c", { desc = "Close window", remap = true })

-- editing
map("n", "dD", "d0", { desc = "Delete to start of line", remap = true })

-- quickfix for blink C-o keymap
map("i", "<C-n>", "<C-o>", { noremap = true, desc = "Execute one normal-mode command" })
