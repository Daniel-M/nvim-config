-- lua/plugins/grug-far.lua
-- Project-wide search & replace powered by ripgrep.
-- <leader>sr  open with empty query
-- <leader>sw  open pre-filled with word under cursor

require("grug-far").setup({
  headerMaxWidth = 80,
  -- Keep results panel open after a replacement so you can verify
  resultsSeparatorLineChar = "─",
  -- Wrap long paths in the results list
  resultLocation = { showColumn = true },
  transports = {
    -- ripgrep flags visible in the UI — user can edit them inline
    ripgrep = {
      extraArgs = "--smart-case",
    },
  },
})

vim.keymap.set({ "n", "x" }, "<leader>sr", function()
  require("grug-far").open()
end, { desc = "Search: grug-far (replace)" })

vim.keymap.set("n", "<leader>sw", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search: grug-far word under cursor" })
