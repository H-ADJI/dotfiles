return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- python stuff
      "pyright",
      "ruff",
      "debugpy",
      "delve",
      "go-debug-adapter",
      -- "black",
      -- golang stuff
      "gopls",
      "iferr",
      "goimports",
      "golines",
      "templ",
      -- javascript
      "typescript-language-server",
      "biome",
      "eslint-lsp",
      -- other stuff
      "clangd",
      "htmx-lsp",
      "taplo",
      "css-lsp",
      -- "sqlfluff",
      "sql-formatter",
      "dockerfile-language-server",
      "docker-compose-language-service",
      "prettierd",
      "shellcheck",
      "shfmt",
      "stylua",
      "bash-language-server",
      "beautysh",
    },
  },
}
