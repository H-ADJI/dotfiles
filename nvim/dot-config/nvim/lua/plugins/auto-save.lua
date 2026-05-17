return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  opts = {
    debounce_delay = 200, -- delay after which a pending save is executed
  },
}
