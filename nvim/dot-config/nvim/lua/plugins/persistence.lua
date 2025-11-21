return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>rS",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>fs",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>rs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session for CWD",
    },
    {
      "<leader>ds",
      function()
        require("persistence").stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
