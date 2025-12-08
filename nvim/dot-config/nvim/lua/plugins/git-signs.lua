return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    Snacks.toggle({
      name = "Git Blame line",
      get = function()
        return require("gitsigns.config").config.current_line_blame
      end,
      set = function(state)
        require("gitsigns").toggle_current_line_blame(state)
      end,
    }):map("<leader>uGB")

    Snacks.toggle({
      name = "Git Signs",
      get = function()
        return require("gitsigns.config").config.signcolumn
      end,
      set = function(state)
        require("gitsigns").toggle_signs(state)
      end,
    }):map("<leader>uGS")
    opts.on_attach = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitsigns-blame",
        callback = function(event)
          local buf = event.buf
          -- Map q and <Esc> to close the blame window
          vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
          vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
        end,
      })
    end
    return opts
  end,
  keys = {
    {
      "<leader>gbl",
      function()
        require("gitsigns").blame_line()
      end,
      desc = "[G]it [B]lame [L]ine",
    },
    {
      "<leader>gbb",
      function()
        require("gitsigns").blame()
      end,
      desc = "[G]it [B]lame [B]uffer",
    },
  },
}
