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
        "gopls",
        "just",
        "dockerls",
        "systemd_ls",
        "tsgo",
        "cssls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "just-lsp",
        "ty",
        "gopls",
        "iferr",
        "goimports",
        "gofumpt",
        "golines",
        "hyprls",
        "ruff",
        "systemd_ls",
        "systemdlint",
        "flake8",
        "mypy",
        "pyrefly",
        "bash-language-server",
        "marksman",
        "markdownlint",
        "biome",
        "pyright",
        "taplo",
        "dockerfile-language-server",
        "typescript-language-server",
        "tsgo",
        "prettierd",
        "css-lsp",
        "shellcheck",
        "shfmt",
        "stylua",
        "beautysh",
      },
    },
  },
}
