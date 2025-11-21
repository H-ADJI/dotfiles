return {
  "xiyaowong/transparent.nvim",
  enabled = false,
  config = function()
    require("transparent").setup({
      extra_groups = {
        "SnackBorder",
        "SnacksTitle",
        "SnackPrompt",
        "SnackPreview",
        "SnackResults",
        "SnackScrollbar",
        "SnackScrollbarThumb",
        "SnacksBackdrop",
        "SnacksNormalNC",
        "SnacksWinBar",
        "SnacksWinBarNC",
        "SnacksPicker",
        "SnacksPickerBorder",
        "SnacksPickerInput",
        "SnacksPickerPreviewTitle",
        "SnacksPickerPrompt",
        "SnacksPickerList",
        "SnacksPickerPreview",
        "SnacksPickerScrollbar",
        "SnacksPickerScrollbarThumb",
        "SnacksPickerCursorLine",
      },
      on_clear = function() end,
    })
    require("transparent").clear_prefix("SnacksNotifier")
    require("transparent").clear_prefix("Which")
    Snacks.toggle("transparency", {
      name = "transparency",
      get = function()
        return vim.g.transparent_enabled
      end,
      set = function(state)
        vim.cmd("TransparentToggle")
      end,
    }):map("<leader>ut")
  end,
}
