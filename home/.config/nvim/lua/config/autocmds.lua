-- This file is automatically loaded by lazyvim.config.init.
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Turn off Paste mode after leaving Insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Fix conceal level for JSON files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
