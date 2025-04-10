return {
	"folke/zen-mode.nvim",
	config = function()
		vim.api.nvim_set_keymap("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true })
		require("zen-mode").setup({
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				width = 180, -- width of the Zen window
				height = 0.98, -- height of the Zen window
			},
		})
	end,
}
