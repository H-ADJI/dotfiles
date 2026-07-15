return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  enabled = true,
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    signature = { enabled = true, window = { show_documentation = false } },
    keymap = { preset = "default", ["<C-c>"] = { "hide", "fallback" }, ["<CR>"] = false },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = true, treesitter_highlighting = true },
      menu = { auto_show = false },
      ghost_text = { enabled = true },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = { lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 } },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = { completion = { menu = { auto_show = false } } },
  },
  opts_extend = { "sources.default" },
}
