-- ~/.config/nvim/init.lua
-- Requires Neovim 0.11+

-- 1. Core settings (no plugin dependencies)
require("options")
require("keymaps")
require("autocmds")

-- 2. Install / load all plugins via vim.pack
require("plugins.pack")

-- 3. Plugin configs — order matters: theme → UI → LSP → completion → tools
require("plugins.colorscheme")
require("plugins.mini")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.blink")
require("plugins.telescope")
require("plugins.lang.typescript")
require("plugins.lang.go")
require("plugins.lang.python")
require("plugins.git")
require("plugins.conform")
require("plugins.hlslens")
require("plugins.colorizer")
require("plugins.claudecode")
require("plugins.ai")
require("plugins.markdown")
require("plugins.trouble")
require("plugins.grug-far")
require("plugins.harpoon")
