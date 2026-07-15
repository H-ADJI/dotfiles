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

map("n", "<leader>rl", function()
  vim.cmd("LspRestart")
end, { desc = "[R]estart [L]SP" })

map("n", "<leader>bb", function()
  vim.cmd("b#")
end, { desc = "Switch to recent buffer" })

map("x", "<", "<gv", { desc = "Indent left and reselect" })
map("x", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<leader>od", function()
  vim.diagnostic.open_float(nil, {
    format = function(diagnostic)
      return string.format("%s [%s]", diagnostic.message, diagnostic.source or "unknown source")
    end,
  })
end, { desc = "[O]pen [D]iagnostics" })

map("n", "<leader>cd", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1] - 1 -- 0-indexed
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

  if #diagnostics == 0 then
    vim.notify("No diagnostics on current line")
    return
  end
  local file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local lines = {}
  for _, d in ipairs(diagnostics) do
    table.insert(lines, string.format("%s:%d:%d %s [%s]", file, d.lnum + 1, d.col + 1, d.message, d.source or "unknown"))
  end
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.notify("Copied " .. #diagnostics .. " diagnostic(s)")
end, { desc = "[C]opy line [D]iagnostics" })

map("n", "<leader>nd", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "[N]ext [D]iagnostic" })

map("n", "<leader>pd", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "[P]revious [D]iagnostic" })

map("n", "<leader>pp", function()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
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

map("n", "dD", "d0", { desc = "Delete to start of line", remap = true })
map("n", "_", "0", { desc = "Start of line", remap = true })
