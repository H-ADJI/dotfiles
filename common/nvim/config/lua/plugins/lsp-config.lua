return {
  "neovim/nvim-lspconfig",
  lazy = false,
  keys = {
    {
      "<leader>rl",
      function()
        vim.cmd("lsp restart")
      end,
      desc = "[R]estart [L]SP",
    },
    {
      "<leader>lsi",
      function()
        vim.cmd("checkhealth vim.lsp")
      end,
      desc = "[L]anguage [S]ervers [I]nfo",
    },
  },
  config = function()
    for _, server in ipairs({
      "lua_ls",
      "just",
      "harper_ls",
      "tinymist",
      "ruff",
      "nixd",
      "yamlls",
      "tsgo",
      "pyright",
      "bashls",
      "marksman",
      "gopls",
      "biome",
      "taplo",
      "dockerls",
    }) do
      vim.lsp.enable(server)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
      end,
    })
  end,
}
