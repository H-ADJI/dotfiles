return {
  "Pocco81/auto-save.nvim",
  opts = {
    write_all_buffers = true,
    trigger_events = { "InsertLeavePre", "TextChanged", "TextChangedI", "BufLeave" },
  },
}
