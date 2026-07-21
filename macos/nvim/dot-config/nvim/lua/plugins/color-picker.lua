return {
  "vi013t/easycolor.nvim",
  enabled = false,
  dependencies = { "stevearc/dressing.nvim" },
  opts = { ui = { mappings = { ["<C-n>"] = "hue_down", ["<C-p>"] = "hue_up" } } },
  keys = { { "<leader>cp", "<cmd>EasyColor<cr>", desc = "Color Picker" } },
}
