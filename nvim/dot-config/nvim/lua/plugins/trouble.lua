return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    {
      "<leader>xx",
      function()
        vim.cmd("Trouble diagnostics toggle filter.buf=0")
      end,
      desc = "Current Buffer Diagnostics",
    },
    {
      "<leader>xX",
      function()
        vim.cmd("Trouble diagnostics toggle")
      end,
      desc = "All buffers Diagnostics",
    },
  },
}
