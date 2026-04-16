-- lua/plugins/hlslens.lua
-- nvim-hlslens: show [x/N] match position overlay when searching.
-- Enhances n/N/*/#/g*/g# with a virtual-text count.

require("hlslens").setup({
  calm_down         = true,   -- clear overlay when cursor moves off the match
  nearest_only      = false,  -- show count on all matches, not just nearest
  nearest_float_when = "auto",
})

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "n",
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "N",
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "*",  [[*<Cmd>lua require('hlslens').start()<CR>]],  kopts)
vim.api.nvim_set_keymap("n", "#",  [[#<Cmd>lua require('hlslens').start()<CR>]],  kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
