-- Telescope plugin configuration
-- local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- Essential dependency
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },  -- FZF-native extension for speed
    "nvim-telescope/telescope-ui-select.nvim",  -- UI Select extension
    "ThePrimeagen/harpoon",  -- Harpoon plugin for project management
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },  -- Devicons if you have Nerd Fonts
    "folke/todo-comments.nvim",  -- Todo comments integration
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--vimgrep",
      },
      file_ignore_patterns = {
        ".git/",
        -- node
        "node_modules/",
        -- rust
        "**/debug/",
        "target/release/",
        -- yarn
        ".yarn/*",
      },
      prompt_prefix = "» ",
      selection_caret = " ",
      multi_icon = "",
      selection_strategy = "reset",
      layout_strategy = "flex", -- flexible layout (horizontal on wide screen, vertical on narrow)
      path_display = { "smart" },
      dynamic_preview_title = true,
      border = true,
      color_devicons = true,
      set_env = {
        ["COLORTERM"] = "truecolor",
      },
      wrap_results = true,
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = { prompt_position = "top", preview_width = 0.5 },
        vertical = { mirror = false },
      },
    },
    pickers = {
      oldfiles = {
        cwd_only = true,
      },
      buffers = {
        sort_mru = true,
        ignore_current_buffer = true,
        -- mappings = {
        --   i = {
        --     ["<Tab>"] = actions.move_selection_next,
        --     ["<S-Tab>"] = actions.move_selection_previous,
        --   },
        --   n = {
        --     ["<Tab>"] = actions.move_selection_next,
        --     ["<S-Tab>"] = actions.move_selection_previous,
        --   },
        -- },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- let me make typos in file names please
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
      -- ["ui-select"] = {
      --   require("telescope.themes").get_cursor(),
      --   require("telescope.themes").get_dropdown(),
      -- },
      media_files = {
        -- Filetypes whitelist
        filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
        -- Find command (defaults to `fd`)
        find_cmd = "fzf",
      },
    },
  },
  keys = {
    { "<leader>ff", builtin.find_files, desc = "[F]ind [F]iles", mode = {"n"} },
    { "<leader>fh", builtin.help_tags, desc = "[F]ind [H]elp", mode = { "n" } },
    { "<leader>fk", builtin.keymaps, desc = "[F]ind [K]eymaps", mode = { "n" } },
    { "<leader>fw", builtin.grep_string, desc = "[F]ind current [W]ord", mode = { "n" } },
    { "<leader>fg", builtin.live_grep, desc = "[F]ind by [G]rep", mode = { "n" } },
    { "<leader>fd", builtin.diagnostics, desc = "[F]ind [D]iagnostics", mode = { "n" } },
    { "<leader><leader>", builtin.buffers, desc = "Find existing buffers", mode = { "n" } },
    {
      "<leader>/",
      mode = { "n" },
      function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
    {
      "<leader>f/",
      mode = { "n" },
      function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[F]ind [/] in Open Files",
    },
    -- Shortcut for searching your Neovim configuration files
    {
      "<leader>fn",
      mode = { "n" },
      function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind [N]eovim files",
    },
    -- Diagnostic keymaps
    { "<leader>qd", mode = { "n" }, vim.diagnostic.setloclist, desc = "Open diagnostic [Q]uickfix list" },
    -- Media searching
    {
      "<leader>fm",
      "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>",
      mode = { "n" },
      desc = "[F]ind [M]edia files",
    },
    {
      "<leader>fmc",
      "<cmd>lua require('telescope').extensions.media_files.media_files_console()<cr>",
      mode = { "n" },
      desc = "[F]ind [M]edia files to Console",
    },
  },
}
