-- lua/options.lua
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "100"
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false         -- statusline shows mode
opt.laststatus = 3           -- global statusline
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Clipboard
opt.clipboard = "unnamedplus"

-- Folding (treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99           -- open all folds by default
opt.foldtext = ""

-- Misc
opt.mouse = "a"
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"     -- live preview of :s substitutions
opt.virtualedit = "block"

-- Disable unused legacy remote-plugin providers (suppresses checkhealth noise)
vim.g.loaded_ruby_provider  = 0
vim.g.loaded_perl_provider  = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider  = 0
