return {
	 "williamboman/mason.nvim",
	config = function()
		require("mason").setup()
		-- require("mason-lspconfig").setup({
		-- 	ensure_installed = {
		-- 		-- python stuff
		-- 		"pyright",
		-- 		"ruff",
		-- 		"black",
		-- 		-- golang stuff
		-- 		"gopls",
		-- 		"iferr",
		-- 		"goimports",
		-- 		"golines",
		-- 		"templ",
		-- 		-- javascript
		-- 		"typescript-language-server",
		-- 		"eslint-lsp",
		-- 		-- other stuff
		-- 		"clangd",
		-- 		"htmx-lsp",
		-- 		"taplo",
		-- 		-- "sqlfluff",
		-- 		"sql-formatter",
		-- 		"dockerfile-language-server",
		-- 		"docker-compose-language-service",
		-- 		"prettierd",
		-- 		"shellcheck",
		-- 		"shfmt",
		-- 		"stylua",
		-- 	},
		-- })
	end,
}
