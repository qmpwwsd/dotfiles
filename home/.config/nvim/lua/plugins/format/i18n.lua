return {
  "yelog/i18n.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local i18n = require("i18n")
    local root = vim.fn.getcwd()  -- current working directory
    local locales_dir = root .. "/i18n/locales"
    local files = vim.fn.glob(locales_dir .. "/*.json", 0, 1)
    local locales = {}

    for _, file in ipairs(files) do
      local name = file:match("([^/]+)%.json$")  -- extract "en" from "en.json"
      if name then table.insert(locales, name) end
    end

    -- Ensure "en" is first
    table.sort(locales, function(a, b)
      if a == "en" then return true end
      if b == "en" then return false end
      return a < b
    end)

    i18n.setup({
      locales = locales,
      sources = { locales_dir .. "/{locales}.json" },
      auto_detect = false,
      activation = "manually",
      keys = {
        { "<C-S-n>", function() i18n.i18n_keys() end,     desc = "Show i18n keys" },
        { "<C-S-b>", function() i18n.next_locale() end,   desc = "Next i18n locale" },
        { "<C-S-j>", function() i18n.toggle_origin() end, desc = "Toggle origin overlay" },
      },
    })
  end,
}
