return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- enabled = false,
    config = function()
      -- vim.cmd([[colorscheme catppuccin-mocha]])
      -- vim.cmd([[colorscheme catppuccin-latte]])
    end,
  },
}
