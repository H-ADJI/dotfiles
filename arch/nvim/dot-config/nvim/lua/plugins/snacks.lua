return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true, size = 1 * 1024 * 1024, line_length = 20000 },
    dashboard = { enabled = true, sections = { { section = "header" }, { section = "startup" } } },
    explorer = { enabled = true },
    indent = { enabled = true, only_scope = false, only_current = true },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
          },
        },
      },
    },
    notifier = { enabled = true, timeout = 1500 },
    scroll = {
      enabled = true,
      animate = { duration = { step = 10, total = 200 }, easing = "linear" },
      animate_repeat = { delay = 100, duration = { step = 5, total = 20 }, easing = "linear" },
    },
    toggle = { enabled = true, which_key = true, notify = true },
    statuscolumn = { enabled = true, folds = { open = true, git_hl = true }, git = { patterns = { "GitSign", "MiniDiffSign" } } },
    quickfile = { enabled = true },
    terminal = { win = { style = "terminal", position = "float", backdrop = 60, border = true, height = 0.8, width = 0.8, zindex = 50 } },
    words = { enabled = false },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "[S]earch Keymaps",
    },
    {
      "<leader>sn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "[S]earch [N]otification History",
    },
    -- LSP stuff
    {
      "<leader>lsc",
      function()
        Snacks.picker.lsp_config()
      end,
      desc = "Lsp Info",
    },
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gi",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "cft",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File [E]xplorer",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = "Find Hidden files",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.files({ cwd = "~/dotfiles/" })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fG",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Find Recent",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Find Projects",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },

    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>sa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "Autocmds",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Search for Plugin Spec",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>bdo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffer",
    },
    {
      "<leader>bda",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Delete All Buffer",
    },
    {
      "<leader>bdd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete current Buffer",
    },
    {
      "<leader>gbL",
      function()
        Snacks.git.blame_line()
      end,
      desc = "[G]it [B]lame [L]ine",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "[G]it [O]pen File in Repo",
      mode = { "n", "v" },
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>tt",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>ts",
      function()
        Snacks.scratch()
      end,
      desc = "[T]oggle [S]cratch Buffer",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>cs",
      function()
        Snacks.scratch.select()
      end,
      desc = "[C]hoose [S]cratch Buffer",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.words():map("<leader>uW")
        Snacks.toggle("diagnostics", {
          name = "Verbose Diagnostics",
          get = function()
            -- Check current diagnostic config
            local cfg = vim.diagnostic.config()
            if cfg then
              return cfg.virtual_lines
            end
            return false
          end,
          set = function(state)
            vim.diagnostic.config({
              virtual_lines = state,
            })
          end,
        }):map("<leader>uvd")
      end,
    })
  end,
}
