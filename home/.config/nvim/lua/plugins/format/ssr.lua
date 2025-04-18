return {
	"cshuaimin/ssr.nvim",
	keys = {
		{
			"<M-f>",
			function()
				require("ssr").open()
			end,
			desc = "Search and replace",
		},
	},
	opts = {
		min_width = 50,
		min_height = 5,
		max_width = 120,
		max_height = 25,
		keymaps = {
			close = "q",
			next_match = "n",
			prev_match = "N",
			replace_confirm = "<cr>",
			replace_all = "<leader><cr>",
		},
	},
}
