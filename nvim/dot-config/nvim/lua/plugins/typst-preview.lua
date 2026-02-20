return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  keys = {
    {
      "<leader>ts",
      function()
        vim.cmd("TypstPreviewToggle")
      end,
      desc = "Typst Preview Toggle",
    },
  },
  opts = {
    open_cmd = "google-chrome-stable %s --new-window",
  },
}
