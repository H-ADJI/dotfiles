local M = {}

local theme_file = vim.fn.stdpath("config") .. "/theme"
local uv = vim.loop

local function apply_theme()
  local mode = vim.trim(vim.fn.readfile(theme_file)[1] or "dark")

  if mode == "light" then
    vim.cmd.colorscheme("catppuccin-latte")
  else
    vim.cmd.colorscheme("catppuccin-mocha")
  end
end

function M.start()
  -- Apply on startup
  apply_theme()

  -- Watch for external changes
  local watcher = uv.new_fs_event()
  watcher:start(
    theme_file,
    {},
    vim.schedule_wrap(function()
      apply_theme()
    end)
  )

  -- Keep the watcher reference alive
  M._watcher = watcher
end

return M
