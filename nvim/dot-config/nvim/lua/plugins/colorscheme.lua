return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({ transparent_background = true })
      vim.cmd([[colorscheme catppuccin-latte]])
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({ options = { transparent = true } })
      vim.cmd("colorscheme github_light_high_contrast")
    end,
  },
}
