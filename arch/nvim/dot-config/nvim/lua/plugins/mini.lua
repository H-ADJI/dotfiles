return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.files").setup()
    require("mini.ai").setup()
    require("mini.move").setup({
        mappings = {
            left = "<leader>hh",
            right = "<leader>ll",
            down = "<leader>jj",
            up = "<leader>kk",
            line_left = "<leader>hh",
            line_right = "<leader>ll",
            line_down = "<leader>jj",
            line_up = "<leader>kk",
        },
    })

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
