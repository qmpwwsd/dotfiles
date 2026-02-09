return {
	"akinsho/bufferline.nvim",
	dependencies = { "echasnovski/mini.icons" },
	version = "*",
	opts = { -- require(bufferline).setup(opts)
		options = {
			mode = "tabs",
			separator_style = "thin",
			show_buffer_close_icons = false,
			show_close_icon = false,
			always_show_bufferline = true,
			color_icons = true,
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					separator = true,
					padding = 1,
				},
			},
			diagnostics = "nvim_lsp",
			indicator = {
				icon = "  ",
				style = "icon",
			},
		},
	},
}
