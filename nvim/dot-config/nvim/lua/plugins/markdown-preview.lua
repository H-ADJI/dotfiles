return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  keys = {
    {
      "<leader>tm",
      function()
        local peek = require("peek")
        if peek.is_open() then
          vim.notify("Markdown Preview Off")
          require("peek").close()
        else
          vim.notify("Markdown Preview On")
          require("peek").open()
        end
      end,
      desc = "Markdown Preview Toggle",
    },
  },
  opts = {
    app = { "google-chrome-stable", "--new-window" },
    theme = "light", -- 'dark' or 'light'
  },
}
