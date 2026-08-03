return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      {
        "<leader>rl",
        function()
          vim.cmd("lsp restart")
        end,
        desc = "[L]anguage [S]ervers [I]nfo",
      },
      {
        "<leader>lsi",
        function()
          vim.cmd("checkhealth vim.lsp")
        end,
        desc = "[L]anguage [S]ervers [I]nfo",
      },
    },
  },
  config = function()
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = { nilness = true, unusedparams = true, unusedwrite = true, useany = true },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })
    vim.lsp.config("harper_ls", { filetypes = { "markdown", "typst" } })
    vim.lsp.config("ruff", {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })

    for _, server in ipairs({
      "lua_ls",
      "just",
      "harper_ls",
      "tinymist",
      "ruff",
      "pyright",
      "bashls",
      "marksman",
      "biome",
      "taplo",
      "dockerls",
      "ts_ls",
      "cssls",
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
