-- lua/plugins/harpoon.lua
-- Quick-access file bookmarks (harpoon2).
-- <leader>ma  add current file to harpoon list
-- <leader>mm  open harpoon menu
-- <leader>m1-4  jump to slot 1-4
-- <leader>mp/<leader>mn  previous/next in list

local harpoon = require("harpoon")
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

-- Add / menu
vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end,
  { desc = "Harpoon: add file" })
vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Harpoon: menu" })

-- Numbered slots
for i = 1, 4 do
  vim.keymap.set("n", "<leader>m" .. i, function()
    harpoon:list():select(i)
  end, { desc = "Harpoon: slot " .. i })
end

-- Cycle through list
vim.keymap.set("n", "<leader>mn", function() harpoon:list():next() end,
  { desc = "Harpoon: next" })
vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end,
  { desc = "Harpoon: prev" })
