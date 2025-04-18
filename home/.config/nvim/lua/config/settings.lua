-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.user_emmet_leader_key = '<Tab>'

vim.g.neovide_input_macos_alt_is_meta = true
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.autoformat = true

-- [[ Setting options ]]
-- See `:help o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

local o = vim.opt
o.encoding = "UTF-8"
o.syntax = "on"
o.title = true
o.termguicolors = true
-- o.confirm = true
o.grepprg = "rg --vimgrep"

-- Make line numbers default
o.number = true
o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
o.mouse = "a"

-- Don't show the mode, since it's already in the status line
o.showmode = false
o.showmatch = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

-- Enable break indent
o.breakindent = true
o.smartindent = true

-- Save undo history
o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
o.signcolumn = "yes"

-- Decrease update time
o.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
o.timeoutlen = 300

-- Configure how new splits should be opened
o.splitright = true
o.splitbelow = true

o.linebreak = true -- Wrap lines at convenient points

o.pumblend = 10 -- Popup blend
o.pumheight = 10 -- Maximum number of entries in a popup

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = false
o.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
-- o.fillchars:append({ eob = " " }) -- remove the ~ from end of buffer
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true

-- Preview substitutions live, as you type!
o.inccommand = "split"

-- Show which line your cursor is on
o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10

o.updatetime = 250

vim.diagnostic.config({
  virtual_text = {
    prefix = "",  -- or "", "▶", "»", "→"
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
