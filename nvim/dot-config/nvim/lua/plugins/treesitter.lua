return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "c",
      "go",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "rust",
      "vim",
      "vimdoc",
      "yaml",
    })
  end,
}
