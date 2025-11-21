return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },
  -- use a release tag to download pre-built binaries
  enabled = true,
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    signature = {
      enabled = true,
      window = { show_documentation = false },
    },
    keymap = {
      preset = "enter",
      ["<C-c>"] = { "hide", "fallback" },
      ["<C-u>"] = { "scroll_signature_up", "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_signature_down", "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "select_prev", "show_signature", "hide_signature", "fallback" },
      ["<C-o>"] = { "accept", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        treesitter_highlighting = true,
      },
      menu = {
        auto_show = false,
      },
      ghost_text = { enabled = true },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
      keymap = {
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-c>"] = { "hide", "fallback" },
        ["<C-o>"] = { "accept", "fallback" },
      },
      completion = { menu = { auto_show = false } },
    },
  },
  opts_extend = { "sources.default" },
  signature = { enabled = true },
}
