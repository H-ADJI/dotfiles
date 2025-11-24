return {
  "nvim-mini/mini.pick",
  version = false,
  -- enabled = false,
  config = function()
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
  end,
  keys = {
    -- {
    --   "<leader><leader>",
    --   function()
    --     require("mini.pick").builtin.files()
    --   end,
    -- },
    -- {
    --   "<leader>ff",
    --   function()
    --     require("mini.pick").builtin.files()
    --   end,
    --   desc = "[F]ind [F]ile",
    -- },
    -- {
    --   "<leader>flg",
    --   function()
    --     require("mini.pick").builtin.grep_live()
    --   end,
    --   desc = "[F]ile [L]ive [G]rep",
    -- },
    {
      "<leader>fg",
      function()
        require("mini.pick").builtin.grep()
      end,
      desc = "[F]ile [G]rep",
    },
    --   {
    --     "<leader>sh",
    --     function()
    --       require("mini.pick").builtin.help()
    --     end,
    --     desc = "[S]earch [H]elp",
    --   },
    --   {
    --     "<leader>fb",
    --     function()
    --       require("mini.pick").builtin.buffers()
    --     end,
    --     desc = "[F]ind [B]uffer",
    --   },
  },
}
