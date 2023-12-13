--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "rmehri01/onenord.nvim",
    config = {
      theme = "dark", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
      --   borders = true, -- Split window borders
      --   fade_nc = false, -- Fade non-current windows, making them more distinguishable
      --   -- Style that is applied to various groups: see `highlight-args` for options
      --   styles = {
      --     comments = "NONE",
      --     strings = "NONE",
      --     keywords = "NONE",
      --     functions = "NONE",
      --     variables = "NONE",
      --     diagnostics = "underline",
      --   },
      --   disable = {
      --     background = false, -- Disable setting the background color
      --     float_background = false, -- Disable setting the background color for floating windows
      --     cursorline = false, -- Disable the cursorline
      --     eob_lines = true, -- Hide the end-of-buffer lines
      --   },
      --   -- Inverse highlight for different groups
      --   inverse = {
      --     match_paren = false,
      --   },
      --   custom_highlights = {}, -- Overwrite default highlight groups
      -- custom_colors = {}, -- Overwrite default colors
    },
  },

  -- Create annotations with one keybind, and jump your cursor in the inserted annotation
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  -- Incremental rename
  -- {
  -- 	"smjonas/inc-rename.nvim",
  -- 	cmd = "IncRename",
  -- 	config = true,
  -- },

  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  -- Go forward/backward with square brackets
  {
    "echasnovski/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")
      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- Better increase/descrease
  -- {
  -- 	"monaqa/dial.nvim",
  --    -- stylua: ignore
  --    keys = {
  --      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
  --      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
  --    },
  -- 	config = function()
  -- 		local augend = require("dial.augend")
  -- 		require("dial.config").augends:register_group({
  -- 			default = {
  -- 				augend.integer.alias.decimal,
  -- 				augend.integer.alias.hex,
  -- 				augend.date.alias["%Y/%m/%d"],
  -- 				augend.constant.alias.bool,
  -- 				augend.semver.alias.semver,
  -- 				augend.constant.new({ elements = { "let", "const" } }),
  -- 			},
  -- 		})
  -- 	end,
  -- },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {
      position = "right",
    },
  },

  -- {
  -- 	"nvim-cmp",
  -- 	dependencies = { "hrsh7th/cmp-emoji" },
  -- 	opts = function(_, opts)
  -- 		table.insert(opts.sources, { name = "emoji" })
  -- 	end,
  -- },
}
