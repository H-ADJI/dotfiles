return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fr", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fR", LazyVim.pick("oldfiles", { cwd = LazyVim.root() }), desc = "Recent Root Dir" },
      {
        "<leader>fu",
        function()
          vim.cmd("Telescope find_files find_command=rg,--ignore,--hidden,--files,-u")
        end,
        desc = "Unrestricted Find",
      },
      { "<leader>gS", "<cmd>Telescope git_branches<cr>", desc = "git switch branch" },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
      { "<leader>sB", ":Telescope file_browser path=%:p:h <CR>", desc = "browse files" },
    },
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
}
