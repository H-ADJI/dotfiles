-- NOTE: override default filetypes
-- TODO: verify diff after/lsp/ vs lsp/

---@type vim.lsp.Config
local config = { filetypes = { "markdown", "typst" } }
return config
