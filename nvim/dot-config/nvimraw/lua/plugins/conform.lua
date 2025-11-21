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
      go = { "gofmt", "golines", "goimports" },
      html = { "prettierd" },
      css = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      json = { "biome" },
      jsonc = { "biome" },
      sh = { "shfmt", "beautysh" },
      zsh = { "beautysh" },
      bash = { "beautysh" },
      toml = { "taplo" },
    },
  },
}
