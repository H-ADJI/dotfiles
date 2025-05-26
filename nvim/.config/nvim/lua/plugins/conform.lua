return {
  "stevearc/conform.nvim",
  keys = {
    { "<leader>lf", ":ConformInfo<CR>", desc = "conform formatters information" },
    -- { "<leader>cf", require("conform").format, mode = { "n", "x", "o", "v" }, desc = "format buffer " },
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },
      go = { "gofmt", "golines", "goimports" },
      sql = { "sql_formatter" },
      html = { "prettierd" },
      css = { "prettierd" },
      json = { "biome" },
      jsonc = { "biome" },
      yaml = { "prettierd" },
      javascript = { "prettierd" },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      sh = { "shfmt", "beautysh" },
      zsh = { "beautysh" },
      bash = { "beautysh" },
      xml = { "xmlformatter" },
    },
    formatters = {
      kdlfmt = {
        command = "kdlfmt",
        args = { "format", "$FILENAME" }, -- Adjust path to your SQL formatter config if needed
        stdin = true,
      },
      -- ruff_format = {
      --   prepend_args = { "--config", "~/.config/ruff.toml" },
      -- },
      sql_formatter = {
        command = "sql-formatter",
        args = { "--config", ".sql-formatter.json" }, -- Adjust path to your SQL formatter config if needed
        stdin = true,
      },
    },
  },
}
