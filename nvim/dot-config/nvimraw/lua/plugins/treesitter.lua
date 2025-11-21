return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  -- opts = {
  --   folds = { enable = true },
  -- },
  config = function()
    require("nvim-treesitter.configs").setup({
      ignore_install = {},
      sync_install = false,
      highlight = {
        enable = true,
      },
      modules = {},
      ensure_installed = {
        "c",
        "lua",
        "yaml",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "python",
        "json",
      },
      auto_install = true,
    })
  end,
}
