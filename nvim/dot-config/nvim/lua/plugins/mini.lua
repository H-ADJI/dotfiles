return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.files").setup({})
    require("mini.pairs").setup({})
    require("mini.move").setup({})
    require("mini.icons").setup({})
    require("mini.hipatterns").setup({})
    require("mini.files").setup({})
    require("mini.ai").setup({})

    local win_config = function()
      local height = math.floor(0.618 * vim.o.lines)
      local width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end
    require("mini.pick").setup({ window = { config = win_config } })

    require("mini.surround").setup({
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
      },
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
