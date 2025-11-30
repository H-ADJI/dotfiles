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
    -- vim.lsp.config("docker-language-server", {
    --   filetypes = { "containerfile" },
    -- })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
      end,
    })
  end,
}
