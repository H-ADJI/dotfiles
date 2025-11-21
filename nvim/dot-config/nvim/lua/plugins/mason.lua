return {
  {
    "mason-org/mason.nvim",
    keys = {
      {
        "<leader>mi",
        function()
          vim.cmd("Mason")
        end,
        mode = { "n", "v" },
        desc = "[M]ason [I]nfo",
      },
    },
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = {
        "lua_ls",
        "pyright",
        "ruff",
        "bashls",
        "hyprls",
        "taplo",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    -- TODO: maybe replace with helper function from lazyvim.org
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "ty",
        "hyprls",
        "ruff",
        "flake8",
        "mypy",
        "pyrefly",
        "bash-language-server",
        "marksman",
        "markdownlint",
        "biome",
        "pyright",
        -- toml
        "taplo",
        -- python stuff
        -- golang stuff
        -- "gopls",
        -- "iferr",
        -- "goimports",
        -- "golines",
        -- javascript
        -- "typescript-language-server",
        -- "eslint-lsp",
        -- "css-lsp",
        -- "html-lsp",
        -- "sql-formatter",
        -- "dockerfile-language-server",
        -- "docker-compose-language-service",
        "prettierd",
        "shellcheck",
        "shfmt",
        "stylua",
        "beautysh",
      },
    },
  },
}
