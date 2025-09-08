return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-web-devicons",
    "folke/trouble.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>ss", '<cmd>lua require("spectre").toggle()<CR>', { desc = "[S]tart [S]pectre" })
    vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "[S]pectre current [w]ord" })
    vim.keymap.set("n", "<leader>sf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "[S]pectre on current [f]ile" })
  end,
}
