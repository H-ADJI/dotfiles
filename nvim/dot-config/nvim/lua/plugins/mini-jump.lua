return {
  "nvim-mini/mini.jump",
  version = false,
  enabled = false,
  opts = {
    delay = {
      -- Delay between jump and highlighting all possible jumps
      highlight = 250,
      -- Delay between jump and automatic stop if idle (no jump is done)
      idle_stop = 2000,
    },
  },
  -- config = function()
  --   require("mini.jump").setup({
  --     delay = {
  --       -- Delay between jump and highlighting all possible jumps
  --       highlight = 250,
  --       -- Delay between jump and automatic stop if idle (no jump is done)
  --       idle_stop = 2000,
  --     },
  --   })
  -- end,
}
