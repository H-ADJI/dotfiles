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
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#cddbf0" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#aec2e7" })
      vim.api.nvim_set_hl(0, "Folded", { fg = "#57606a", bg = "#aec2e7" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#0969da" })
    end,
  },
}
