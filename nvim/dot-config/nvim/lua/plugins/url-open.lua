return {
  "sontungexpt/url-open",
  event = "VeryLazy",
  cmd = "URLOpenUnderCursor",
  keys = {
    {
      "<leader>ou",
      function()
        vim.cmd("URLOpenUnderCursor")
      end,
      desc = "Open Url",
    },
    {
      "<leader>hu",
      function()
        vim.cmd("URLOpenHighlightAll")
        vim.defer_fn(function()
          vim.cmd("URLOpenHighlightAllClear")
        end, 5000)
      end,
      desc = "Highlight urls",
    },
  },
  opts = {
    highlight_url = {
      cursor_move = {
        enabled = false,
      },
    },
  },
}
