return {
  "stevearc/oil.nvim",
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    require("oil").setup({
      columns = { "icon" },
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
      win_options = {
        wrap = true,
      },
      filesystem = {
        window = {
          mappings = {
            ["<leader>p"] = "image_wezterm", -- " or another map
          },
        },
        commands = {
          image_wezterm = function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              require("image_preview").PreviewImage(node.path)
            end
          end,
        },
      },
    })

    -- Open parent dir in current window
    vim.keymap.set("n", "pp", "<cmd>Oil<CR>", { desc = "Open parent directory" })

    -- Open parent dir in floating window
    vim.keymap.set("n", "<leader>pp", require("oil").toggle_float, { desc = "Open directory in float window" })
  end,
}
