return {
  "nvim-mini/mini.clue",
  enabled = false,
  version = false,
  -- config = function()
  --   require("mini.clue").setup({
  --     window = {
  --       delay = 300,
  --     },
  --     triggers = {
  --       { mode = "n", keys = "<leader>" },
  --       { mode = "x", keys = "<Leader>" },
  --     },
  --   })
  -- end,
  opts = {
    window = {
      delay = 300,
    },
    triggers = {
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<Leader>" },
    },
  },
}
