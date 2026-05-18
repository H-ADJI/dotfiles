return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- fix for ruff lsp showing notification missing capabilities notification
    lsp = { hover = { silent = true }, signature = { auto_open = { enabled = false } } },
    presets = { lsp_doc_border = true },
  },
  dependencies = { "MunifTanjim/nui.nvim" },
}
