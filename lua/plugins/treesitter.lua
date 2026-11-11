-- lua/plugins/treesitter.lua
-- nvim-treesitter rewrite API (Neovim 0.12+).
-- Highlighting is auto-enabled per filetype by the plugin's runtime files.
-- Setup only needed to change install_dir; parsers installed via .install().
--
-- PREREQUISITE: tree-sitter-cli must be installed.
--   brew install tree-sitter
--
-- After first load, run :TSUpdate to compile/update all parsers.

-- Optional setup (defaults are fine for most setups)
require("nvim-treesitter").setup({
  -- install_dir = vim.fn.stdpath("data") .. "/site",  -- default
})

-- Install parsers for the languages we use.
-- This is async; restart Neovim or run :TSUpdate after first install.
require("nvim-treesitter").install({
  -- Core
  "lua", "vim", "vimdoc", "query",
  -- TypeScript / JS / React
  "typescript", "tsx", "javascript",
  -- Python
  "python",
  -- Go
  "go", "gomod", "gosum", "gowork",
  -- Infra / config
  "terraform", "hcl",
  "json", "yaml", "toml",
  "dockerfile",
  -- Web
  "html", "css",
  -- Docs
  "markdown", "markdown_inline",
  -- Shell
  "bash",
  -- Misc
  "regex",
  -- Go templates + comment parsing (required by go.nvim optional features)
  "gotmpl", "comment",
})

-- ── nvim-treesitter-textobjects ──────────────────────────────────────────────
-- Configuration (select + move behaviour)
require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,   -- jump forward to the next textobj if not on one
    selection_modes = {
      ["@function.outer"]  = "V",  -- linewise for functions
      ["@class.outer"]     = "V",  -- linewise for classes
      ["@parameter.outer"] = "v",  -- charwise for parameters
    },
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,   -- add to jumplist so <C-o>/<C-i> work
  },
})

local sel  = require("nvim-treesitter-textobjects.select")
local mov  = require("nvim-treesitter-textobjects.move")
local swp  = require("nvim-treesitter-textobjects.swap")

-- ── Select text objects ──────────────────────────────────────────────────────
-- af/if  function    ac/ic  class    aa/ia  argument/parameter
-- ab/ib  block       al/il  loop     ai/ii  conditional
local sel_map = {
  { "af", "@function.outer"   },
  { "if", "@function.inner"   },
  { "ac", "@class.outer"      },
  { "ic", "@class.inner"      },
  { "aa", "@parameter.outer"  },
  { "ia", "@parameter.inner"  },
  { "ab", "@block.outer"      },
  { "ib", "@block.inner"      },
  { "al", "@loop.outer"       },
  { "il", "@loop.inner"       },
  { "ai", "@conditional.outer"},
  { "ii", "@conditional.inner"},
}
for _, pair in ipairs(sel_map) do
  local lhs, query = pair[1], pair[2]
  vim.keymap.set({ "x", "o" }, lhs, function()
    sel.select_textobject(query, "textobjects")
  end, { desc = "TS select " .. query })
end

-- ── Move between text objects ────────────────────────────────────────────────
-- ]f/[f   next/prev function start   ]F/[F  next/prev function end
-- ]c/[c   next/prev class            ]a/[a  next/prev parameter
-- (]c/[c for hunk is in git.lua — treesitter ones map ]C/[C for class end)
local move_map = {
  { "]f",  "next_start",    "@function.outer"  },
  { "[f",  "prev_start",    "@function.outer"  },
  { "]F",  "next_end",      "@function.outer"  },
  { "[F",  "prev_end",      "@function.outer"  },
  { "]C",  "next_start",    "@class.outer"     },
  { "[C",  "prev_start",    "@class.outer"     },
  { "]a",  "next_start",    "@parameter.inner" },
  { "[a",  "prev_start",    "@parameter.inner" },
}
local go = {
  next_start = function(q) mov.goto_next_start(q, "textobjects") end,
  next_end   = function(q) mov.goto_next_end(q,   "textobjects") end,
  prev_start = function(q) mov.goto_previous_start(q, "textobjects") end,
  prev_end   = function(q) mov.goto_previous_end(q,   "textobjects") end,
}
for _, entry in ipairs(move_map) do
  local lhs, direction, query = entry[1], entry[2], entry[3]
  vim.keymap.set({ "n", "x", "o" }, lhs, function()
    go[direction](query)
  end, { desc = "TS " .. direction .. " " .. query })
end

-- ── Swap parameters ──────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>sp", function()
  swp.swap_next("@parameter.inner")
end, { desc = "TS swap next param" })
vim.keymap.set("n", "<leader>sP", function()
  swp.swap_previous("@parameter.inner")
end, { desc = "TS swap prev param" })
