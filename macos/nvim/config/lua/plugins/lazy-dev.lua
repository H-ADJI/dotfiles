return {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = { "DrKJeff16/wezterm-types" },
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  },
}
