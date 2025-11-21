return {
  "nvim-mini/mini.files",
  version = false,
  opts = {},
  -- config = function()
  --   require("mini.files").setup({})
  -- end,
  keys = {
    {
      "<leader>fe",
      function()
        if not MiniFiles.close() then
          MiniFiles.open()
        end
      end,
      desc = "Open Mini Files",
    },
    {
      "<Esc>",
      function()
        if not MiniFiles.close() then
          vim.cmd(":nohlsearch")
        end
      end,
      desc = "Open Mini Files",
    },
  },
}
