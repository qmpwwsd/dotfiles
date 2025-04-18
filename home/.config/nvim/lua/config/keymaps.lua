local map = vim.keymap.set

-- ##########################
-- ## General Key Mappings ##
-- ##########################

-- Reset terminal navigation (ensure proper terminal handling)
map("t", "<C-w>", "<C-w>")

-- Disable arrow keys in normal mode (encourage Vim motion)
local function disable_arrows()
  return "<cmd>echo 'Use vim motion!<CR>'"
end

map("n", "<left>", disable_arrows())
map("n", "<right>", disable_arrows())
map("n", "<up>", disable_arrows())
map("n", "<down>", disable_arrows())

-- Miscellaneous normal mode mappings
map("n", "<Esc>", "<cmd>nohlsearch<CR>")  -- Clear search highlights
map("i", "jj", "<Esc>")  -- Fast exit insert mode
map("n", "<C-a>", "gg<S-v>G")  -- Select all content

-- #######################
-- ## Window Management ##
-- #######################

-- Window navigation
map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Go to below window" })
map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Go to above window" })
map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window
map("n", "<C-w><left>", "<C-w><", { desc = "Resize window left" })
map("n", "<C-w><right>", "<C-w>>", { desc = "Resize window right" })
map("n", "<C-w><up>", "<C-w>+", { desc = "Resize window up" })
map("n", "<C-w><down>", "<C-w>-", { desc = "Resize window down" })

-- ##################
-- ## Tab Management ##
-- ##################

-- Tabs
map("n", "te", "tabedit", { desc = "Edit tab" })
map("n", "<tab>", ":tabnext<Return>", { desc = "Next tab" })
map("n", "<S-tab>", ":tabprev<Return>", { desc = "Previous tab" })
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ########################
-- ## Window Splitting ##
-- ########################

-- Window split management
map("n", "<leader>sv", "<c-W>s", { desc = "Split window vertically" })
map("n", "<leader>sh", "<c-W>v", { desc = "Split window horizontally" })
map("n", "<leader>se", "<c-W>=", { desc = "Equalize window sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Vim Maximizer
map("n", "<leader>s+", "<cmd>MaximizerToggle<CR>", { desc = "Toggle Vim maximizer" })

-- ##############################
-- ## Search & Navigation Mappings ##
-- ##############################

-- Navigation through quickfix list
map("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<leader>j", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- Undo tree toggle
map("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })

-- ##########################
-- ## Terminal Mode Mappings ##
-- ##########################

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ######################
-- ## Custom Navigation ##
-- ######################

-- Navigate to function start/end
map("n", "[[", function()
  vim.fn.search("^<(template<bar>script<bar>style)", "bW")
end, { desc = "Navigate to function start" })

map("n", "]]", function()
  vim.fn.search("^<(template)<bar>script<bar>style", "W")
end, { desc = "Navigate to function end" })

-- ##################
-- ## Plugin Mappings ##
-- ##################

-- Live Server
map("n", "<leader>ls", ":split | term live-server<CR>", { desc = "Launch Live Server", noremap = true, silent = true })

-- SSR (Search and Replace)
map({ "n", "x" }, "<leader>sr", function() require("ssr").open() end, { desc = "Search and Replace (SSR)" })

