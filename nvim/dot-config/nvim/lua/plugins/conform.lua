return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>fi",
      function()
        vim.cmd("ConformInfo")
      end,
      desc = "[F]ormatters [I]nfo",
    },
    {
      "<leader>gg",
      function()
        require("conform").format()
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },
      go = { "gofumpt", "golines", "goimports", "gopls" },
      c = { "clang_format" },
      html = { "prettierd" },
      css = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      json = { "biome" },
      jsonc = { "biome" },
      sh = { "shfmt", "beautysh" },
      zsh = { "beautysh" },
      bash = { "beautysh" },
      toml = { "taplo" },
      typst = { "prettypst" },
      rust = { "rustfmt" },
    },
    formatters = {
      rustfmt = {
        command = "rustfmt",
        stdin = true,
      },
    },
  },
}
