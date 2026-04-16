-- lua/plugins/trouble.lua
-- trouble.nvim v3: project-wide diagnostics, symbols, quickfix panel.
require("trouble").setup({
  modes = {
    diagnostics = { auto_close = false },
  },
})

-- <leader>xx  workspace diagnostics
-- <leader>xb  buffer diagnostics
-- <leader>xs  document symbols
-- <leader>xq  quickfix list
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
  { desc = "Trouble: workspace diagnostics" })
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "Trouble: buffer diagnostics" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>",
  { desc = "Trouble: document symbols" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>",
  { desc = "Trouble: quickfix" })
