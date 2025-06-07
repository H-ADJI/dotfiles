return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>fE", -- aliased to <leader>e
      function()
        require("neo-tree.command").execute({ toggle = true, position = "float", dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", tposition = "float", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", position = "float", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
}
