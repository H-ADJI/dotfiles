return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
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
      "zsh",
      "bash",
      "query",
      "rust",
      "vim",
      "vimdoc",
      "yaml",
      "toml",
      "nix",
      "kdl",
    })
  end,
}
