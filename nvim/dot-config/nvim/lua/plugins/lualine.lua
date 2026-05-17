return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          path = 4,
        },
      },
      lualine_x = {
        "lsp_status",
      },
      lualine_y = {
        "progress",
        {
          "searchcount",
          maxcount = 9999,
          timeout = 500,
        },
      },
      lualine_z = { "location" },
    },
  },
}
