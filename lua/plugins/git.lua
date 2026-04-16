-- lua/plugins/git.lua
-- gitsigns.nvim: gutter signs + hunk operations (stage/reset/preview/blame).
-- mini.git (in mini.lua) handles git log/show/commit UI.
-- gitsigns handles line-level hunk management.

function _G.diffThisBranch()
  local branch = vim.fn.input("Branch: ", "")
  require("gitsigns").diffthis(branch)
end

require("gitsigns").setup({
  signs = {
    add          = { text = "▎" },
    change       = { text = "▎" },
    delete       = { text = "" },
    topdelete    = { text = "" },
    changedelete = { text = "▎" },
    untracked    = { text = "▎" },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text     = true,
    virt_text_pos = "eol",
    delay         = 600,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
  preview_config = { border = "rounded" },
  on_attach = function(bufnr)
    local gs  = package.loaded.gitsigns
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation (expr so ]c/[c still work in diff mode)
    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, "Git: next hunk")
    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, "Git: prev hunk")

    -- Hunk operations
    map({ "n", "v" }, "<leader>hs", gs.stage_hunk,                            "Git: stage hunk")
    map({ "n", "v" }, "<leader>hr", gs.reset_hunk,                            "Git: reset hunk")
    map("n",          "<leader>hS", gs.stage_buffer,                          "Git: stage buffer")
    map("n",          "<leader>hu", gs.undo_stage_hunk,                       "Git: undo stage hunk")
    map("n",          "<leader>hR", gs.reset_buffer,                          "Git: reset buffer")
    map("n",          "<leader>hp", gs.preview_hunk,                          "Git: preview hunk")

    -- Blame
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,     "Git: blame line (full)")
    map("n", "<leader>tb", gs.toggle_current_line_blame,                      "Git: toggle line blame")

    -- Diff views
    map("n", "<leader>hd",  gs.diffthis,                                      "Git: diffthis")
    map("n", "<leader>hD",  function() gs.diffthis("~") end,                  "Git: diffthis ~")
    map("n", "<leader>hm",  function() gs.diffthis("main") end,               "Git: diffthis main")
    map("n", "<leader>hM",  diffThisBranch,                                   "Git: diffthis branch…")
    map("n", "<leader>td",  gs.toggle_deleted,                                "Git: toggle deleted")

    -- Text object: inner hunk (useful with d/y/c)
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",                "Git: select hunk")
  end,
})
