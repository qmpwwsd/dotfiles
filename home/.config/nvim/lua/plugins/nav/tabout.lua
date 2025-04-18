local skip_features_filetypes = require("util.ft").skip_features_filetypes

return {
	"abecodes/tabout.nvim",
	event = { "VeryLazy" },
	opts = {
		exclude = skip_features_filetypes,
	},
}
