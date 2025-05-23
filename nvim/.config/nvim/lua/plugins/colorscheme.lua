return {
  { "ellisonleao/gruvbox.nvim" },
  { "tomasiser/vim-code-dark" },
  { "catppuccin/nvim", opts = { transparent_background = true }, name = "catppuccin", priority = 1000 },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>tw",
        function()
          vim.cmd("colorscheme default")
        end,
        desc = "toggle white colorscheme",
      },
      {
        "<leader>tn",
        function()
          vim.cmd("colorscheme catppuccin-mocha")
        end,
        desc = "toggle dark colorscheme",
      },
    },
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
