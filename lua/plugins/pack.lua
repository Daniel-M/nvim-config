-- lua/plugins/pack.lua
-- Single source of truth for all plugin URLs.
-- vim.pack.add() clones on first run and keeps plugins up to date.
-- Run :checkhealth vim.pack to diagnose issues.

vim.pack.add({
  -- UI & editing (mini.nvim — one repo, 40+ modules)
  "https://github.com/echasnovski/mini.nvim",

  -- Syntax highlighting and text objects
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

  -- LSP server config definitions (works with Neovim native LSP)
  "https://github.com/neovim/nvim-lspconfig",

  -- Completion engine (use stable v1 branch)
  "https://github.com/Saghen/blink.cmp",

  -- Fuzzy finder
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",

  -- Color themes
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/rmehri01/onenord.nvim",
  "https://github.com/catppuccin/nvim",

  -- TypeScript: async type checking + human-readable errors
  "https://github.com/dmmulroy/tsc.nvim",
  "https://github.com/dmmulroy/ts-error-translator.nvim",

  -- Go: full IDE-like experience on top of gopls
  "https://github.com/ray-x/guihua.lua",   -- UI dependency for go.nvim
  "https://github.com/ray-x/go.nvim",

  -- Python: quick virtual environment switching
  "https://github.com/AckslD/swenv.nvim",

  -- Git hunk operations (stage/reset/preview/blame) — replaces mini.diff
  "https://github.com/lewis6991/gitsigns.nvim",

  -- Per-filetype formatting (prettier, black, gofumpt) with LSP fallback
  "https://github.com/stevearc/conform.nvim",

  -- Inline hex/rgb/hsl color preview (maintained fork of norcalli/nvim-colorizer.lua)
  "https://github.com/catgoose/nvim-colorizer.lua",

  -- Enhanced search count overlay (n/N/*/# show [x/y] position)
  "https://github.com/kevinhwang91/nvim-hlslens",

  -- AI: Claude Code sidebar (uses CLI auth, same protocol as VS Code extension)
  "https://github.com/coder/claudecode.nvim",

  -- AI: chat panel + inline edits (needs ANTHROPIC_API_KEY when used)
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/Exafunction/windsurf.nvim",

  -- Markdown inline rendering
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  -- Diagnostics panel
  "https://github.com/folke/trouble.nvim",

  -- npm package version info (nui.nvim is its UI dep)
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/vuki656/package-info.nvim",

  -- JSON/YAML schema store (used by jsonls + yamlls)
  "https://github.com/b0o/SchemaStore.nvim",

  -- File bookmarks (harpoon2 branch)
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  -- Project-wide search & replace (ripgrep-based, grug-far.nvim)
  "https://github.com/MagicDuck/grug-far.nvim",
})
