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

  config = function()
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      return
    end
    url_open.setup({
      highlight_url = {
        cursor_move = {
          enabled = false,
        },
      },
    })
  end,
}
