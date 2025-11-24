-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.o.clipboard = "unnamedplus"
  end,
})

-- BUG: not floating after first call
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "help", "man" },
--   callback = function(event)
--     local buf = event.buf
--     -- If already in a floating window, do nothing
--     -- if vim.api.nvim_win_get_config(0).relative ~= "" then
--     --   return
--     -- end
--     if vim.tbl_contains(vim.v.argv, "+Man!") then
--       return
--     end
--     -- Delay closing + floating until after the buffer is populated
--     vim.schedule(function()
--       local win = vim.fn.bufwinid(buf)
--       if win ~= -1 then
--         vim.api.nvim_win_close(win, true)
--       end
--       Snacks.win({
--         buf = buf,
--         width = 0.5,
--         height = 0.8,
--         border = "rounded",
--         enter = true,
--         on_win = function(ctx)
--           vim.api.nvim_set_option_value("wrap", true, { win = ctx.win })
--           vim.api.nvim_set_option_value("linebreak", true, { win = ctx.win })
--         end,
--         on_close = function(ctx)
--           vim.api.nvim_set_option_value("wrap", false, { win = ctx.win })
--           vim.api.nvim_set_option_value("linebreak", false, { win = ctx.win })
--         end,
--       })
--     end)
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})
