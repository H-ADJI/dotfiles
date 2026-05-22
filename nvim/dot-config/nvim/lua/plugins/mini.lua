return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.files").setup()
    require("mini.move").setup()
    require("mini.files").setup()
    require("mini.ai").setup()

    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({ highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } })

    local win_config = function()
      local height = math.floor(0.6 * vim.o.lines)
      local width = math.floor(0.6 * vim.o.columns)
      local start_row = math.floor(0.5 * (vim.o.lines - height))
      local start_col = math.floor(0.5 * (vim.o.columns - width))
      return { anchor = "NW", height = height, width = width, row = start_row, col = start_col }
    end
    require("mini.pick").setup({ window = { config = win_config } })

    require("mini.surround").setup({
      mappings = { add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF", highlight = "gsh", replace = "gsr" },
      n_lines = 20,
    })
  end,

  keys = {
    {
      "<leader>fg",
      function()
        MiniPick.builtin.grep()
      end,
      desc = "[F]ile [G]rep",
    },
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
