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
      go = { "gofumpt", "golines", "goimports" },
      nix = { "nixfmt" },
      c = { "clang_format" },
      asm = { "asmfmt" },
      javascript = { "biome" },
      typescript = { "biome" },
      html = { "biome" },
      css = { "biome" },
      json = { "biome" },
      jsonc = { "biome" },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      yaml = { "yamlfmt" },
      sh = { "shfmt", "beautysh" },
      zsh = { "beautysh" },
      bash = { "beautysh" },
      toml = { "taplo" },
      typst = { "prettypst" },
      rust = { "rustfmt" },
      kdl = { "kdlfmt" },
      dockerfile = { "dockerfmt" },
    },
    formatters = {
      rustfmt = { command = "rustfmt", stdin = true },
      kdlfmt = { args = { "format", "--kdl-version", "v1", "-" }, stdin = true },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
