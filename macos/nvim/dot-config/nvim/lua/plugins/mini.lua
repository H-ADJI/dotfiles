return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.files").setup()
    require("mini.move").setup()
    require("mini.ai").setup()

    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({ highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } })

    require("mini.surround").setup({
      mappings = { add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF", highlight = "gsh", replace = "gsr" },
      n_lines = 20,
    })
  end,

  keys = {
    {
      "<leader>fe",
      function()
        if not MiniFiles.close() then
          MiniFiles.open()
        end
      end,
      desc = "Open MiniFiles",
    },
    {
      "<Esc>",
      function()
        if not MiniFiles.close() then
          vim.cmd(":nohlsearch")
        end
      end,
      desc = "Close MiniFiles",
    },
  },
}
