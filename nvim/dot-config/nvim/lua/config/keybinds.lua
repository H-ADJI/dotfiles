local map = vim.keymap.set

map("n", "zz", function()
  vim.cmd("qa")
end, { desc = "[Q]uit all" })

map("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end, { desc = "Disable Search Highlight" })

map("n", "<leader>li", function()
  vim.cmd("Lazy")
end, { desc = "[L]azy [I]nfo" })

-- save
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("w")
  vim.notify("File Saved")
end, { desc = "Save file" })

map("n", "<leader>rl", function()
  vim.cmd("LspRestart")
end, { desc = "[R]estart [L]SP" })

-- buffers
map("n", "<leader>rb", function()
  vim.cmd("e")
end, { desc = "[R]eload [B]uffer" })

map("n", "<leader>bb", function()
  vim.cmd("b#")
end, { desc = "Switch to recent buffer" })

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
map("n", "_", "0", { desc = "Start of line", remap = true })
