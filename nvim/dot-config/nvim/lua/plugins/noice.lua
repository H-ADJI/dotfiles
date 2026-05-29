return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- NOTE: fix ruff and pyright distracting notification
    lsp = { progress = { throttle = 200 }, hover = { silent = true }, signature = { auto_open = { enabled = false } } },
    presets = { lsp_doc_border = true },
  },
  dependencies = { "MunifTanjim/nui.nvim" },
}
