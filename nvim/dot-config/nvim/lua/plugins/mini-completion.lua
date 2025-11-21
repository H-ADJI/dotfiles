return {
  "nvim-mini/mini.completion",
  enabled = false,
  version = false,
  opts = {},
  config = function()
    require("mini.completion").setup({
      mappings = {
        scroll_down = "<C-l>",
        scroll_up = "<C-f>",
      },
    })
    local imap_expr = function(lhs, rhs)
      vim.keymap.set("i", lhs, rhs, { expr = true })
    end
    imap_expr("<C-j>", [[pumvisible() ? "\<C-n>" : "\<C-j>"]])
    imap_expr("<C-k>", [[pumvisible() ? "\<C-p>" : "\<C-k>"]])
  end,
}
