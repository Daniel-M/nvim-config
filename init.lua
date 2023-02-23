local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

g.mapleader = " "

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use 'David-Kunz/cmp-npm'
  -- use 'David-Kunz/jester'
  -- use 'David-Kunz/treesitter-unit'
  use 'L3MON4D3/LuaSnip'
  use 'Mofiqul/dracula.nvim'
  use 'folke/tokyonight.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'
  use 'lewis6991/gitsigns.nvim'
  use 'marko-cerovac/material.nvim'
  use 'mfussenegger/nvim-dap'
  use 'mhartington/formatter.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'rafamadriz/friendly-snippets'
  use 'ray-x/go.nvim'
  use { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' }
  use 'ray-x/navigator.lua'
  use 'ryanoasis/vim-devicons'
  use 'saadparwaiz1/cmp_luasnip'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'tpope/vim-commentary'
  use 'voldikss/vim-floaterm'
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'williamboman/mason.nvim'
  use 'windwp/nvim-autopairs'
  use 'yassinebridi/vim-purpura'
  use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'norcalli/nvim-colorizer.lua'
end
)


-- default options
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.laststatus = 3
opt.mouse = 'a'
opt.splitright = true
opt.splitbelow = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.number = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.scrolloff = 10
-- opt.relativenumber = true
vim.cmd('set number')
vim.cmd('set noignorecase')
vim.cmd('set norelativenumber')
-- set diffopt+=vertical " starts diff mode in vertical split
opt.cmdheight = 1
-- set shortmess+=c " don't need to press enter so often
opt.signcolumn = 'yes'
opt.updatetime = 520
opt.undofile = true
cmd('filetype plugin on')
opt.backup = false
g.netrw_banner = false
g.netrw_liststyle = 3
g.markdown_fenced_languages = { 'javascript', 'js=javascript', 'json=javascript' }

-- opt.path:append({ "**" })
vim.cmd([[set path=$PWD/**]])
vim.keymap.set('n', '<leader>v', ':e $MYVIMRC<CR>')

require("mason").setup()
require("mason-lspconfig").setup()

require("navigator").setup({
  mason = true,
  lsp = {
    disable_lsp = { 'flow' }, -- enabling flow breaks navigator with mason
  }
})

require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },

  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'npm' },
    { name = 'luasnip', keyword_length = 2 }
  },
    {
      { name = 'buffer', keyword_length = 3 },
    }),

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },

  mapping = {
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  -- formatting = {
  --   format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  -- }
})

-- local lspconfig = require('lspconfig')
-- local lsp_defaults = lspconfig.util.default_config

-- lsp_defaults.capabilities = vim.tbl_deep_extend(
--   'force',
--   lsp_defaults.capabilities,
--   require('cmp_nvim_lsp').default_capabilities()
-- )

-- lspconfig.lua_ls.setup({})

local nvim_lsp = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
local servers = { 'tsserver', 'gopls', 'pyright', 'pylsp', 'graphql', 'eslint' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  }
end
require('ufo').setup()


-- local nvim_lsp = require 'lspconfig'
-- local servers = { 'tsserver', 'gopls', 'pyright', 'pylsp', 'graphql', 'eslint' }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--   }
-- end

vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end)
vim.keymap.set('n', 'gD', function() vim.lsp.buf.implementation() end)
vim.keymap.set('n', '<c-k>', function() vim.lsp.buf.signature_help() end)
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end)
vim.keymap.set('n', 'gR', function() vim.lsp.buf.rename() end)
vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', 'gA', ':Telescope lsp_range_code_actions<CR>')

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.expand = function()
  -- print("hurray!!")
  if ls.expand_or_jumpable() then
    return t("<Plug>luasnip-expand-or-jump")
  end
  return ''
end

_G.expand_back = function()
  -- print("hurray!!")
  if ls.jumpable(-1) then
    return t("<Plug>luasnip-jump-prev")
  end
  return ''
end

vim.api.nvim_set_keymap('i', '<c-j>', 'v:lua.expand()', { expr = true })
vim.api.nvim_set_keymap('i', '<c-k>', 'v:lua.expand_back()', { expr = true })
vim.api.nvim_set_keymap('s', '<c-j>', 'v:lua.expand()', { expr = true })
vim.api.nvim_set_keymap('s', '<c-k>', 'v:lua.expand_back()', { expr = true })

vim.keymap.set('n', '<leader>ls', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>')

_G.test_dap = function()
  local dap = require 'dap'
  -- dap.terminate(nil, nil, function()
  --   vim.wait(2000, function()
  --     local session = dap.session()
  --     return session and session.initialized
  --   end)
  dap.run({
    args = { "--no-cache" },
    console = "integratedTerminal",
    cwd = "/Users/d065023/projects/DevOnDuty/VimAsIDE",
    disableOptimisticBPs = true,
    port = 9229,
    protocol = "inspector",
    request = "launch",
    runtimeArgs = { "--inspect-brk", "foo.js" },
    -- skipFiles = { "file:///<node_internals>/**/*.js" },
    skipFiles = { "promiseInitHookWithDestroyTracking" },
    sourceMaps = "inline",
    type = "node2"
  })
  -- end)
end



-- lewis6991/gitsigns.nvim
function diffThisBranch()
  local branch = vim.fn.input("Branch: ", "")
  require "gitsigns".diffthis(branch)
end

require('gitsigns').setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    -- Navigation
    vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

    -- Actions
    vim.keymap.set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    vim.keymap.set('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    vim.keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    vim.keymap.set('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    vim.keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    vim.keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    vim.keymap.set('n', '<leader>hb', function() require "gitsigns".blame_line { full = true } end)
    vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    vim.keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    vim.keymap.set('n', '<leader>hD', function() require "gitsigns".diffthis("~") end)
    vim.keymap.set('n', '<leader>hm', function() require "gitsigns".diffthis("main") end)
    vim.keymap.set('n', '<leader>hM', diffThisBranch)
    vim.keymap.set('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    vim.keymap.set('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    vim.keymap.set('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

-- mhartington/formatter.nvim
vim.keymap.set('n', '<leader>F', ':Format<CR>')
require('formatter').setup({
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations a
  filetype = {
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,
    },
    javascript = {
      function()
        return {
          exe = "./node_modules/.bin/prettier",
          args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote --no-semi" },
          stdin = true,
        }
      end,

      function()
        return {
          exe = "./node_modules/.bin/eslint",
          args = { "--stdin", "--stdin-filename", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) },
          stdin = true,
        }
      end,
    },
    graphql = {
      -- require("formatter.filetypes.graphql").prettier,
      function()
        return {
          exe = "./node_modules/.bin/prettier",
          args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote --no-semi" },
          stdin = true,
        }
      end
    },
    gql = {
      require("formatter.filetypes.graphql").prettier,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    python = {
      require("formatter.filetypes.python").autopep8,
    },
    -- rust = {
    --   function()
    --     return {
    --       exe = "rustfmt",
    --       stdin = true
    --     }
    --   end
    -- },
    -- sql = {
    --    function()
    --       return {
    --         exe = "sqlformat",
    --         args = {vim.api.nvim_buf_get_name(0), '-a'},
    --         stdin = true
    --       }
    --     end
    -- },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
})
local telescope_actions = require("telescope.actions.set")

local fixfolds = {
  hidden = true,
  attach_mappings = function(_)
    telescope_actions.select:enhance({
      post = function()
        vim.cmd(":normal! zx")
      end,
    })
    return true
  end,
}

local actions = require("telescope.actions")


require('telescope').setup {
  defaults = { file_ignore_patterns = { "node_modules" } },
  pickers = {
    buffers = fixfolds,
    find_files = fixfolds,
    git_files = fixfolds,
    grep_string = fixfolds,
    live_grep = fixfolds,
    oldfiles = fixfolds,
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim-telescope/telescope.nvim
_G.telescope_find_files_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  require("telescope.builtin").find_files({ search_dirs = { _path } })
end
_G.telescope_live_grep_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  require("telescope.builtin").live_grep({ search_dirs = { _path } })
end
_G.telescope_files_or_git_files = function()
  local utils = require('telescope.utils')
  local builtin = require('telescope.builtin')
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  if ret == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end
vim.keymap.set('n', '<leader>fD', function() telescope_live_grep_in_path() end)
vim.keymap.set('n', '<leader><space>', function() telescope_files_or_git_files() end)
vim.keymap.set('n', '<leader>fd', function() telescope_find_files_in_path() end)
vim.keymap.set('n', '<leader>ft', function() telescope_find_files_in_path("./tests") end)
vim.keymap.set('n', '<leader>fT', function() telescope_live_grep_in_path("./tests") end)
-- vim.keymap.set('n', '<leader>ff', ':Telescope live_grep<CR>')
-- vim.keymap.set('n', '<leader>fo', ':Telescope file_browser<CR>')
vim.keymap.set('n', '<leader>fn', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fr', ':Telescope resume<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope git_branches<CR>')
vim.keymap.set('n', '<c-\\>', ':Telescope buffers<CR>')
vim.keymap.set('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>')
vim.keymap.set('n', '<leader>ff', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>FF', ':Telescope grep_string<CR>')

-- David-Kunz/cmp-npm
require('cmp-npm').setup({ ignore = { "beta", "rc" } })

-- windwp/nvim-autopairs
local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = { 'string' }, -- it will not add a pair on that treesitter node
    javascript = { 'template_string' },
    java = false, -- don't check treesitter on java
  },
  disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
})
local ts_conds = require('nvim-autopairs.ts-conds')


-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua")
      :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
  Rule("$", "$", "lua")
      :with_pair(ts_conds.is_not_ts_node({ 'function' }))
})
-- end nvim-autopairs config

-- CDS
-- cmd([[
-- augroup MyCDSCode
--      autocmd!
--      autocmd BufReadPre,FileReadPre *.cds set ft=cds
-- augroup END
-- ]])
-- local lspconfig = require'lspconfig'
-- local configs = require'lspconfig.configs'
-- if not configs.sapcds_lsp then
--   configs.sapcds_lsp = {
--     default_config = {
--       cmd = {vim.fn.expand("$HOME/projects/startcdslsp")};
--       filetypes = {'cds'};
--       root_dir = lspconfig.util.root_pattern('.git', 'package.json'),
--       settings = {};
--     };
--   }
-- end
-- if lspconfig.sapcds_lsp.setup then
--   lspconfig.sapcds_lsp.setup{
--     -- capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--   }
-- end

vim.keymap.set('n', '<leader><esc><esc>', ':tabclose<CR>')

-- vim.g.material_style = "darker"
-- vim.cmd 'colorscheme material'
vim.opt.fillchars = {
  horiz     = '█',
  horizup   = '█',
  horizdown = '█',
  vert      = '█',
  vertleft  = '█',
  vertright = '█',
  verthoriz = '█',
}
vim.cmd('colorscheme purpura')
-- vim.cmd('colorscheme dracula')
vim.cmd('set background=dark')
vim.cmd('set termguicolors')
-- vim.cmd 'colorscheme tokyonight'
-- vim.cmd 'colorscheme gruvbox'
-- vim.cmd 'colorscheme github_dark'



vim.g.floaterm_width = 0.95
vim.g.floaterm_height = 0.95
vim.keymap.set('n', '<leader>g', ':FloatermNew lazygit<CR>')


cmd('set foldmethod=expr')
cmd('set foldexpr=nvim_treesitter#foldexpr()')

vim.keymap.set('n', '<leader>n', ':tabe ~/tmp/notes.md<CR>')

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.cds = {
  install_info = {
    -- local path or git repo
    url = "~/apps/tree-sitter-cds",
    files = { "src/parser.c", "src/scanner.c" }
  },
  filetype = "cds",
  -- additional filetypes that use this parser
  used_by = { "cdl", "hdbcds" }
}

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = {
    "bash",
    "c",
    "go",
    "help",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  -- indent = {
  --   enable = true
  -- },
  endwise = {
    enabled = true
  }
}
-- mfussenegger/nvim-dap
local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/apps/node/out/src/nodeDebug.js' },
}

-- require('dap').set_log_level('INFO')
dap.defaults.fallback.terminal_win_cmd = '20split new'
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🟦', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

vim.keymap.set('n', '<leader>dh', function() require "dap".toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set('n', '<A-k>', function() require "dap".step_out() end)
vim.keymap.set('n', "<A-l>", function() require "dap".step_into() end)
vim.keymap.set('n', '<A-j>', function() require "dap".step_over() end)
vim.keymap.set('n', '<A-h>', function() require "dap".continue() end)
vim.keymap.set('n', '<leader>dn', function() require "dap".run_to_cursor() end)
vim.keymap.set('n', '<leader>dc', function() require "dap".terminate() end)
vim.keymap.set('n', '<leader>dR', function() require "dap".clear_breakpoints() end)
vim.keymap.set('n', '<leader>de', function() require "dap".set_exception_breakpoints({ "all" }) end)
vim.keymap.set('n', '<leader>da', function() require "debugHelper".attach() end)
vim.keymap.set('n', '<leader>dA', function() require "debugHelper".attachToRemote() end)
vim.keymap.set('n', '<leader>di', function() require "dap.ui.widgets".hover() end)
vim.keymap.set('n', '<leader>d?',
  function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
vim.keymap.set('n', '<leader>ds', ':Telescope dap frames<CR>')
-- vim.keymap.set('n', '<leader>dc', ':Telescope dap commands<CR>')
vim.keymap.set('n', '<leader>db', ':Telescope dap list_breakpoints<CR>')

require('nvim-dap-virtual-text').setup()

-- David-Kunz/jester
-- require 'jester'.setup({ path_to_jest = "/usr/local/bin/jest" })
-- vim.keymap.set('n', '<leader>tt', function() require "jester".run() end)
-- vim.keymap.set('n', '<leader>t_', function() require "jester".run_last() end)
-- vim.keymap.set('n', '<leader>tf', function() require "jester".run_file() end)
-- vim.keymap.set('n', '<leader>d_', function() require "jester".debug_last() end)
-- vim.keymap.set('n', '<leader>df', function() require "jester".debug_file() end)
-- vim.keymap.set('n', '<leader>dq', function() require "jester".terminate() end)
-- vim.keymap.set('n', '<leader>dd', function() require "jester".debug() end)

-- lua language server
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = os.getenv('HOME') .. '/apps/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require 'lspconfig'.lua_ls.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" };
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.keymap.set('n', '[b', ':bnext<CR>')
vim.keymap.set('n', ']b', ':bprev<CR>')

-- David-Kunz/treesitter-unit
-- vim.keymap.set('x', 'u', ':<c-u>lua require"treesitter-unit".select()<CR>')
-- vim.keymap.set('o', 'u', ':<c-u>lua require"treesitter-unit".select()<CR>')
-- vim.keymap.set('x', 'u', ':<c-u>lua require"treesitter-unit".select(true)<CR>')
-- vim.keymap.set('o', 'u', ':<c-u>lua require"treesitter-unit".select(true)<CR>')
-- require"treesitter-unit".enable_highlighting()

-- local tunit = require'treesitter-unit'
-- vim.keymap.set('x', 'iu', function() require'treesitter-unit'.select() end)
-- vim.keymap.set('x', 'au', function() require'treesitter-unit'.select(true) end)
-- vim.keymap.set('o', 'iu', function() require'treesitter-unit'.select() end)
-- vim.keymap.set('o', 'au', function() require'treesitter-unit'.select(true) end)

-- custom folder icon
require 'nvim-web-devicons'.setup({
  override = {
    lir_folder_icon = {
      icon = "",
      color = "#7ebae4",
      name = "LirFolderNode"
    },
  }
})
-- use visual mode
function _G.LirSettings()
  vim.api.nvim_buf_set_keymap(0, 'x', 'J', ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
    { noremap = true, silent = true })

  -- echo cwd
  vim.api.nvim_echo({ { vim.fn.expand('%:p'), 'Normal' } }, false, {})
end

vim.cmd [[augroup lir-settings]]
vim.cmd [[  autocmd!]]
vim.cmd [[  autocmd Filetype lir :lua LirSettings()]]
vim.cmd [[augroup END]]

-- global mark I for last edit
vim.cmd [[autocmd InsertLeave * execute 'normal! mI']]

-- highlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}]])

-- kyazdani42/nvim-tree.lua
require('nvim-tree').setup({
  hijack_cursor = true,
  update_focused_file = { enable = true },
  view = {
    width = 40
  }
})
vim.keymap.set('n', '\\', ':NvimTreeToggle<CR>', { silent = true })

vim.keymap.set('n', 'gq', ':bd!<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')

vim.cmd('iabbrev :tup: 👍')
vim.cmd('iabbrev :tdo: 👎')
vim.cmd('iabbrev :smi: 😊')
vim.cmd('iabbrev :sad: 😔')
vim.cmd('iabbrev darkred #8b0000')
vim.cmd('iabbrev darkgreen #006400')

_G.term_buf_of_tab = _G.term_buf_of_tab or {}
_G.term_buf_max_nmb = _G.term_buf_max_nmb or 0

function spawn_terminal()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd('vs | terminal')
  local cur_buf = vim.api.nvim_get_current_buf()
  _G.term_buf_max_nmb = _G.term_buf_max_nmb + 1
  vim.api.nvim_buf_set_name(cur_buf, "Terminal " .. _G.term_buf_max_nmb)
  table.insert(_G.term_buf_of_tab, cur_tab, cur_buf)
  vim.cmd(':startinsert')
end

function toggle_terminal()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  local term_buf = term_buf_of_tab[cur_tab]
  if term_buf ~= nil then
    local cur_buf = vim.api.nvim_get_current_buf()
    if cur_buf == term_buf then
      vim.cmd('q')
    else
      vim.cmd('vert sb' .. term_buf)
      vim.cmd(':startinsert')
    end
  else
    spawn_terminal()
    vim.cmd(':startinsert')
  end
end

vim.keymap.set('n', '<c-y>', toggle_terminal)
vim.keymap.set('i', '<c-y>', '<ESC>:lua toggle_terminal()<CR>')
vim.keymap.set('t', '<c-y>', '<c-\\><c-n>:lua toggle_terminal()<CR>')
-- cmd([[
-- if has('nvim')
--    au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
-- endif]])

_G.send_line_to_terminal = function()
  local curr_line = vim.api.nvim_get_current_line()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  local term_buf = term_buf_of_tab[cur_tab]
  if term_buf == nil then
    spawn_terminal()
    term_buf = term_buf_of_tab[cur_tab]
  end
  for _, chan in pairs(vim.api.nvim_list_chans()) do
    if chan.buffer == term_buf then
      chan_id = chan.id
    end
  end
  vim.api.nvim_chan_send(chan_id, curr_line .. '\n')
end

vim.keymap.set('n', '<leader>x', ':lua send_line_to_terminal()<CR>')

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
  }
}

vim.keymap.set('n', '<c-o>', '<c-o>zz')
vim.keymap.set('n', '<c-i>', '<c-i>zz')

-- 'L3MON4D3/LuaSnip'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- lualine

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require('colorizer').setup()

-- ldelossa/gh.nvim
-- require('litee.lib').setup()
-- require('litee.gh').setup({
--   prefer_https_remote = true
-- })

-- go.nvim
require('go').setup({
  lsp_cfg = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  },
})
-- require("go.format").gofmt()  -- gofmt only
-- require("go.format").goimport()  -- goimport + gofmt

-- nvim-telescope/telescope-ui-select.nvim
require("telescope").load_extension("ui-select")

-- require("github-theme").setup({
--   theme_style = "dark",
-- })

vim.keymap.set('i', '<c-o>', '<esc><s-o>')
vim.keymap.set('n', '<leader>p', ':PackerSync<CR>')
-- vim.api.nvim_create_autocmd('BufHidden',  {
--     pattern  = '[dap-terminal]*',
--     callback = function(arg)
--       vim.schedule(function() vim.api.nvim_buf_delete(arg.buf, { force = true }) end)
--     end
-- })
