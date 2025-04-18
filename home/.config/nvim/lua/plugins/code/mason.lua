return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  opts = {
    log_level = vim.log.levels.OFF,
    ensure_installed = {
      "stylua",
    },
  },
}
