return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      "<leader>lsi",
      function()
        vim.cmd("LspInfo")
      end,
      desc = "[L]anguage [S]ervers [I]nfo",
    },
  },
  -- opts = {},
  -- config call is necessary for some reason
  config = function()
    -- vim.lsp.config()
  end,
}
