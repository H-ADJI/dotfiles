return {
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader>fr", false },
			{
				"<leader>fu",
				"<cmd> Telescope find_files find_command=rg,--ignore,--hidden,--files,-u<cr>",
				desc = "unrestricted find",
			},
			{ "<leader>gS", "<cmd>Telescope git_branches<cr>", desc = "git switch branch" },
			{
				"<leader>fp",
				function()
					require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
				end,
				desc = "Find Plugin File",
			},
		},
		opts = {
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
			},
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		keys = {
			{ "<leader>sB", ":Telescope file_browser path=%:p:h <CR>", desc = "browse files" },
		},
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		keys = {
			{ "<leader>fr", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "[F]ind [R]ecent buffer" },
		},
	},
}
