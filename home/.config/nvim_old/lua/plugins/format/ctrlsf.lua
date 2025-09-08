return {
  "dyng/ctrlsf.vim",
  config = function ()
    vim.keymap.set("n", "<leader>F", function()
      -- Prompt the user for input
      local search_term = vim.fn.input("Enter variable to find (default: word under cursor): ")

      -- If input is empty, use the word under the cursor
      if search_term == "" then
        search_term = vim.fn.expand("<cword>") -- Get the word under the cursor
      end

      -- Run the CtrlSF command with the search term
      vim.cmd("CtrlSF " .. search_term)
    end, { desc = "Find variable" })
  end
}
