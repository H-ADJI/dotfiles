return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin-latte]])
    end,
  },
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = { debounce_delay = 200 },
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, { path = "snacks.nvim", words = { "Snacks" } } } },
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "npm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        -- python = { "flake8" },
      }
    end,
  },
  { "linux-cultist/venv-selector.nvim", ft = "python", keys = { { ",v", "<cmd>VenvSelect<cr>" } } },
  { "folke/which-key.nvim", event = "VeryLazy", opts = { preset = "helix" } },
}
