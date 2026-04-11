-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.number = true
vim.o.autowriteall = true
vim.o.undofile = false
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 8
vim.o.list = false
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.o.swapfile = false
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.scrolloff = 20
vim.o.confirm = true
vim.o.undofile = true
vim.opt.fillchars:append({ eob = " " })

require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("catppuccin-latte")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      },
      config = function()
        require("telescope").setup()
      end,
    },
    {
      "Pocco81/auto-save.nvim",
      opts = {
        write_all_buffers = true,
        trigger_events = { "InsertLeavePre", "TextChanged", "TextChangedI", "BufLeave" },
      },
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      keys = {
        {
          "<leader>bdd",
          function()
            Snacks.bufdelete()
          end,
          desc = "Delete current Buffer",
        },
        {
          "<leader>e",
          function()
            Snacks.explorer()
          end,
          desc = "File [E]xplorer",
        },
      },
      opts = {
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "startup" },
          },
        },
        explorer = {
          enabled = true,
        },
      },
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
})

local map = vim.keymap.set
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("w")
  vim.notify("File Saved")
end, { desc = "Save file" })
map("n", "zz", function()
  vim.cmd("qa")
end, { desc = "[Q]uit all" })
map("n", "<leader>bb", function()
  vim.cmd("b#")
end, { desc = "Switch to recent buffer" })
map("x", "<", "<gv", { desc = "Indent left and reselect" })
map("x", ">", ">gv", { desc = "Indent right and reselect" })
map("n", "<c-n>h", "0", { desc = "Go to start of line" })
map("n", "<c-n>l", "$", { desc = "Go to end of line" })
map("n", "dD", "d0", { desc = "Delete to start of line", remap = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})
