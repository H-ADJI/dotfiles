vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reload buffers when files change on disk (e.g. external tools writing files)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Check for external file changes",
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Also poll so changes show up even while idle in tmux (no focus events)
vim.fn.timer_start(2000, function()
  vim.cmd("checktime")
end, { ["repeat"] = -1 })

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
