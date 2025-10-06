return {
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ensure_installed = {
        -- python stuff
        "pyright",
        "ruff",
        "debugpy",
        "delve",
        "go-debug-adapter",
        -- rust stuff
        "rust-analyzer",
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
        "html-lsp",
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
        "just-lsp",
        "jinja-lsp",
        "djlint",
      },
    },
  },
}
