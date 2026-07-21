return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "r",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-space>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({ actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" } })
      end,
      desc = "Treesitter Incremental Selection",
    },
  },
}
