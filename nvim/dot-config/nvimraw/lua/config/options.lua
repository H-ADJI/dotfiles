-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- See `:help mapleader`
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
-- vim.diagnostic.config({
  -- virtual_lines = true,
  -- virtual_text = true,
-- })
