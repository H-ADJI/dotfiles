return {
  "vi013t/easycolor.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  opts = {
    ui = {
      mappings = {
        q = "close_window", -- The action when q is pressed, close window by default.
        j = "move_cursor_down", -- The action when j is pressed, move cursor down by default.
        k = "move_cursor_up", -- The action when k is pressed, move cursor up by default.
        h = "move_cursor_left", -- The action when h is pressed, move cursor left by default.
        l = "move_cursor_right", -- The action when l is pressed, move cursor right by default.
        ["<C-n>"] = "hue_down", -- The action when <Down> is pressed, hue down by default.
        ["<C-p>"] = "hue_up", -- The action when <Up> is pressed, hue up by default.
        ["<Enter>"] = "insert_color", -- The action when <Enter> is pressed, insert color by default.
        t = "edit_formatting_template", -- The action when t is pressed, edit formatting template by default.
      },
    },
  },
  keys = { { "<leader>cp", "<cmd>EasyColor<cr>", desc = "Color Picker" } },
}
