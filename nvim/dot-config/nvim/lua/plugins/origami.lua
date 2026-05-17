return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  enabled = false,
  opts = {
    foldKeymaps = {
      setup = false,
    },
  },
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
