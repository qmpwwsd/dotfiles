local ts = {
	"nvim-treesitter/nvim-treesitter",
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		-- Extra textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- Commenting for vue SFCs
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			ft = { "html", "vue", "react" },
			init = function()
				vim.g.skip_ts_context_commentstring_module = true
			end,
			config = true,
		},
		-- Auto insert closing tags
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup({
					enable_close_on_slash = false, -- disable case: `<div /` becomes `<div /div>`
					filetypes = {
						"html",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
						"xml",
					},
				})
			end,
		},
	},
	opts = {
		-- either "all" or a list of languages
		ensure_installed = {
			"comment",
			"lua",
			"javascript",
			"jsdoc",
			"typescript",
			"tsx",
			"fish",
			"json",
			"yaml",
			"html",
			"css",
			"scss",
			"vue",
			"svelte",
			"markdown", -- lsp, lspsaga diagnostic
			"markdown_inline", -- lsp, lspsaga diagnostic
		},
		ignore_install = {
			"haskell",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
		auto_install = true, -- Automatically install missing parsers when entering buffer
		textobjects = {
			-- custom text objects
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- track in jumplist (<C-o>, <C-i>)
				goto_next_start = {
					["]["] = "@function.outer",
					[")("] = "@class.outer",
				},
				goto_next_end = {
					["]]"] = "@function.outer",
					["))"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["(("] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["()"] = "@class.outer",
				},
			},
			lsp_interop = {
				enable = true,
				border = "single",
				peek_definition_code = {
					["<Leader>pf"] = "@function.outer",
					["<Leader>pc"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<Alt-j>"] = "@parameter.inner",
				},
				swap_previous = {
					["<Alt-k>"] = "@parameter.outer",
				},
			},
		},
	},
}

return {
	ts,
}
