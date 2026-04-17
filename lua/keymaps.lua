-- lua/keymaps.lua
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Better movement in wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window resize
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",           { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>",  { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>",  { desc = "Increase width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- Indenting in visual stays in visual
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move selected lines up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Better paste (don't yank replaced text)
map("v", "p", '"_dP', { desc = "Paste without yank" })

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Spell
map("n", "<leader>us", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell check" })

-- Quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- New line without insert mode
map("n", "<leader>o", "o<Esc>", { desc = "New line below" })
map("n", "<leader>O", "O<Esc>", { desc = "New line above" })
