return {
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  "mbbill/undotree",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  { "godlygeek/tabular", cmd = "Tabularize" },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
      }
    end,
  },
  {
    -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
      },
    },
  }
}
