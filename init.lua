-- Turn these off at startup, will be enabled later just before loading the theme
vim.cmd([[
    syntax off
    filetype off
    filetype plugin indent off
]])

vim.opt.ruler = false
vim.opt.hidden = true
vim.opt.ignorecase = false 
-- vim.opt.ignorecase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.cul = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.updatetime = 250 -- update interval for gitsigns
vim.opt.timeoutlen = 400
vim.opt.clipboard = "unnamedplus"

-- disable nvim intro
vim.opt.shortmess:append("sI")

-- disable tilde on end of buffer: https://github.com/  neovim/neovim/pull/8546#issuecomment-643643758
vim.cmd("let &fcs='eob: '")

-- Numbers
vim.opt.number = true
vim.opt.numberwidth = 2
-- vim.opt.relativenumber = true

-- Indenline
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 4

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>hl")

vim.g.mapleader = "\\"
vim.g.auto_save = false

-- disable builtin vim plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them
--[[ remove this line

map("n", "dd", [=[ "_dd ]=], opt)
map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=], opt)

 this line too ]]
--

-- escape with 'jk' mapping
vim.api.nvim_set_keymap("i", "jk", "<esc>", {})
vim.api.nvim_set_keymap("v", "jk", "<esc>", {})
vim.api.nvim_set_keymap("t", "jk", "<esc>", {})

-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', opt)

-- OPEN TERMINALS --
map("n", "<C-l>", [[<Cmd> vnew +terminal/bin/bash | setlocal nobuflisted <CR>]], opt) -- term over right
map("n", "<C-x>", [[<Cmd> 10new +terminal/bin/bash | setlocal nobuflisted <CR>]], opt) --  term bottom
map("n", "<C-t>t", [[<Cmd> terminal/bin/bash <CR>]], opt) -- term buffer

-- copy whole file content
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], opt)

-- toggle numbers
map("n", "<leader>n", [[ <Cmd> set nu!<CR>]], opt)

-- Truezen.nvim
map("n", "<leader>zz", ":TZAtaraxis<CR>", opt)
map("n", "<leader>zm", ":TZMinimalist<CR>", opt)
map("n", "<leader>zf", ":TZFocus<CR>", opt)

map("n", "<C-s>", ":w <CR>", opt)

-- Commenter Keybinding
--map("n", "<leader>/", ":CommentToggle<CR>", opt)
--map("v", "<leader>/", ":CommentToggle<CR>", opt)
map("n", "<C-c>", ":CommentToggle<CR>", opt)
map("v", "<C-c>", ":CommentToggle<CR>", opt)

-- compe stuff
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

--_G.tab_complete = function()
--    if vim.fn.pumvisible() == 1 then
--        return t "<C-n>"
--    elseif check_back_space() then
--        return t "<Tab>"
--    else
--        return vim.fn["compe#complete"]()
--    end
--end
--
--_G.s_tab_complete = function()
--    if vim.fn.pumvisible() == 1 then
--        return t "<C-p>"
--    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
--        return t "<Plug>(vsnip-jump-prev)"
--    else
--        return t "<S-Tab>"
--    end
--end
--
--function _G.completions()
--    local npairs
--    if
--        not pcall(
--            function()
--                npairs = require "nvim-autopairs"
--            end
--        )
--     then
--        return
--    end
--
--    if vim.fn.pumvisible() == 1 then
--        if vim.fn.complete_info()["selected"] ~= -1 then
--            return vim.fn["compe#confirm"]("<CR>")
--        end
--    end
--    return npairs.check_break_line_char()
--end
--
----  compe mappings
--map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
--map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
--map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--map("i", "<CR>", "v:lua.completions()", {expr = true})

-- nvimtree
--map("n", "<C-n>", ":NvimTreeToggle<CR>", opt)
map("n", "<leader>et", ":NvimTreeToggle<CR>", opt)

-- format code
map("n", "<leader>fm", [[<Cmd> Neoformat<CR>]], opt)

-- dashboard stuff
map("n", "<Leader>fw", [[<Cmd> Telescope live_grep<CR>]], opt)
map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-- Telescope
map("n", "<Leader>gt", [[<Cmd> Telescope git_status <CR>]], opt)
map("n", "<Leader>cm", [[<Cmd> Telescope git_commits <CR>]], opt)
map("n", "<Leader>ff", [[<Cmd> Telescope find_files <CR>]], opt)
map("n", "<Leader>fp", [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>Telescope buffers<CR>]], opt)
map("n", "<Leader>fh", [[<Cmd>Telescope help_tags<CR>]], opt)
map("n", "<Leader>fo", [[<Cmd>Telescope oldfiles<CR>]], opt)

-- bufferline tab stuff
map("n", "<S-t>", ":enew<CR>", opt) -- new buffer
map("n", "<C-t>b", ":tabnew<CR>", opt) -- new tab
map("n", "<S-x>", ":bd!<CR>", opt) -- close tab

-- move between tabs
map("n", "<TAB>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
map("n", "<S-TAB>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)

-- use ESC to turn off search highlighting
map("n", "<Esc>", ":noh<CR>", opt)

-- get out of terminal with jk
map("t", "jk", "<C-\\><C-n>", opt)


-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.cmd [[colorscheme purpura]]

return require("packer").startup(function()
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    "dense-analysis/ale",
    ft = {
            "sh",
            "zsh",
            "bash",
            "c",
            "cpp",
            "cmake",
            "html",
            "markdown",
            "racket",
            "vim",
            "tex",
            "lua",
    },
    cmd = "ALEEnable",
    config = "vim.cmd[[ALEEnable]]"
  }

  use {
      "williamboman/nvim-lsp-installer",
  }

  use {
      "neovim/nvim-lspconfig",
      -- after = "nvim-lspinstall",
      -- after = "nvim-lsp-installer",
      config = function()
          require "plugins.lspconfig"
      end
  }

  use {
      "onsails/lspkind-nvim",
      event = "BufRead",
      config = function()
        local present, lspkind = pcall(require, "lspkind")
        if present then
        lspkind.init()
        end
      end
  }


  -- Plugins can have dependencies on other plugins
  use {
    "hrsh7th/nvim-cmp",
    -- event = "InsertEnter",
    config = function()
        require "plugins.cmp"
    end,
    --opt = true,
    requires = {{"hrsh7th/vim-vsnip"}, {"hrsh7th/vim-vsnip-integ"}}
  }

  use {"hrsh7th/cmp-nvim-lsp"}
  use {"hrsh7th/cmp-buffer"}
  use {"hrsh7th/cmp-path"}
  use {"hrsh7th/cmp-cmdline"}

  -- Post-install/update hook with neovim command
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Post-install/update hook with call of vimscript function with argument
  use { "glacambre/firenvim", run = function() vim.fn["firenvim#install"](0) end }

  -- Use specific branch, dependency and run lua file after load
  -- use {
  --   "glepnir/galaxyline.nvim",
  --   branch = "main", 
  --   -- config = function() require"statusline" end,
  --   requires = {"kyazdani42/nvim-web-devicons"}
  -- }

  use { "vim-airline/vim-airline" }
  use {"vim-airline/vim-airline-themes" }

  -- Use dependency and run lua function after load
  use {
    "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end
  }

  -- You can specify multiple plugins in a single call
  use {"tjdevries/colorbuddy.vim"}

  -- You can alias plugin names
  use {"dracula/vim", as = "dracula"}

  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
        -- require "plugins.blankline"
        local ok, res = xpcall(require, debug.traceback, "plugins.blankline")
        if not (ok) then
          print("Error loading blankline")
        end
    end 
  }

  use {
    "yassinebridi/vim-purpura",
    after = "packer.nvim",
    config = function()
       vim.cmd([[
         syntax on
         filetype on
         filetype plugin indent on
       ]]) 
    end
  }


  -- use {
  --     "kabouzeid/nvim-lspinstall",
  --     event = "BufRead"
  -- }

  use {
    "terrortylor/nvim-comment",
    cmd = "CommentToggle",
    config = function()
	    local present, nvim_comment = pcall(require, "nvim_comment")
    if present then
        nvim_comment.setup()
    end
    end
  }
  
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {} end
  }


  -- use {
  --   "kyazdani42/nvim-web-devicons",
  --   -- after = "nvim-base16.lua",
  --   -- config = function()
  --     -- require "plugins.icons"
  --   -- end
  -- }

  use {
    "nvim-lua/plenary.nvim",
    event = "BufRead"
  }

  use {
    "nvim-lua/popup.nvim",
    after = "plenary.nvim"
  }

  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require "plugins.telescope"
    end
  }

  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cmd = "Telescope"
  }

  use {
    "nvim-telescope/telescope-media-files.nvim",
    cmd = "Telescope"
  }
end)

