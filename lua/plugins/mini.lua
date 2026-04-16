-- lua/plugins/mini.lua
-- Configure all mini.nvim modules used in this config.

-- Sensible defaults (whitespace display, search, etc.)
require("mini.basics").setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = "default",
  },
  mappings = {
    basic = false,        -- we manage keymaps in keymaps.lua
    option_toggle_prefix = [[\]],
    windows = false,
  },
  autocommands = { basic = true },
})

-- Icons (requires a Nerd Font in your terminal)
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()  -- make devicons-dependent plugins work

-- Statusline: MODE | branch  filename            diagnostics  LSP  filetype | % line:col
require("mini.statusline").setup({
  use_icons        = true,
  set_vim_settings = true,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location      = MiniStatusline.section_location({ trunc_width = 75 })
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end,
    inactive = function()
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      return MiniStatusline.combine_groups({
        { hl = "MiniStatuslineInactive", strings = { filename } },
      })
    end,
  },
})

-- Tabline (buffer tabs)
require("mini.tabline").setup({
  show_icons = true,
  set_vim_settings = true,
  tabpage_section = "right",
})

-- File explorer
require("mini.files").setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 50,
  },
  options = { use_as_default_explorer = true },
})
vim.keymap.set("n", "<leader>e", function()
  if not MiniFiles.close() then MiniFiles.open() end
end, { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>E", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = "Explorer: current file" })

-- Commenting (gc / gbc)
require("mini.comment").setup()

-- Snippets (integrated with blink.cmp)
require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_lang(),   -- per-filetype snippets
    require("mini.snippets").gen_loader.from_file(
      vim.fn.stdpath("config") .. "/snippets/global.json"
    ),
  },
})

-- Git integration
require("mini.git").setup()
vim.keymap.set("n", "<leader>gs", "<cmd>lua MiniGit.show_at_cursor()<CR>", { desc = "Git: show at cursor" })
vim.keymap.set("n", "<leader>gb", function()
  local line = vim.fn.line(".")
  MiniGit.show_range_history({ line1 = line, line2 = line })
end, { desc = "Git: blame line" })
vim.keymap.set({ "n", "x" }, "<leader>gd", "<cmd>lua MiniGit.show_diff_source()<CR>", { desc = "Git: diff source" })

-- Auto-pairs
require("mini.pairs").setup({
  modes = { insert = true, command = false, terminal = false },
})

-- Surround (sa = add, sd = delete, sr = replace, sf/sF = find, sh = highlight)
require("mini.surround").setup({
  mappings = {
    add            = "sa",
    delete         = "sd",
    find           = "sf",
    find_left      = "sF",
    highlight      = "sh",
    replace        = "sr",
    update_n_lines = "sn",
  },
})

-- Extended text objects (af/if = function, ac/ic = class, etc.)
require("mini.ai").setup({ n_lines = 500 })

-- Notifications
require("mini.notify").setup({
  window = { config = { border = "rounded" } },
})
vim.notify = MiniNotify.make_notify()

-- Which-key style hints
-- Use a local ref: gen_clues calls are evaluated before setup() sets the global.
local clue = require("mini.clue")
clue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "z" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "s" },
  },
  clues = {
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.z(),
    { mode = "n", keys = "<Leader>f", desc = "+find/file" },
    { mode = "n", keys = "<Leader>g", desc = "+git" },
    { mode = "n", keys = "<Leader>l", desc = "+lsp" },
    { mode = "n", keys = "<Leader>b", desc = "+buffer" },
    { mode = "n", keys = "<Leader>m", desc = "+marks/harpoon" },
    { mode = "n", keys = "<Leader>s", desc = "+search/swap" },
  },
  window = { config = { border = "rounded" }, delay = 400 },
})

-- Indent scope visualization
-- Same pattern: use local ref so gen_animation is available before setup returns.
local indentscope = require("mini.indentscope")
indentscope.setup({
  symbol = "│",
  options = { try_as_border = true },
  draw = { animation = indentscope.gen_animation.none() },
})

-- Highlight word under cursor
require("mini.cursorword").setup()

-- Move lines/selections (Alt+hjkl)
require("mini.move").setup({
  mappings = {
    left  = "<A-h>",
    right = "<A-l>",
    down  = "<A-j>",
    up    = "<A-k>",
    line_left  = "<A-h>",
    line_right = "<A-l>",
    line_down  = "<A-j>",
    line_up    = "<A-k>",
  },
})

-- Clean buffer deletion (preserves window layout)
require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete() end, { desc = "Buffer: delete" })
vim.keymap.set("n", "<leader>bD", function() MiniBufremove.delete(0, true) end, { desc = "Buffer: force delete" })

-- Extra pickers/utilities (used by telescope + lsp)
require("mini.extra").setup()

-- Enhanced f/F/t/T: after jumping, press f/F again to go to next/prev match
-- (replaces the need for flash.nvim's char mode)
require("mini.jump").setup({
  delay = { highlight = 250, idle_stop = 0 },
})

-- Jump anywhere visible with labeled targets (replaces flash.nvim s/S)
-- <CR> in normal/visual/op-pending: shows labels on every 2-char spot; type
-- the label character(s) to teleport there.
require("mini.jump2d").setup({
  view     = { dim = true, n_steps_ahead = 2 },
  mappings = { start_jumping = "<CR>" },
})

-- ── Session management (replaces persistence.nvim) ───────────────────────────
-- Sessions are named after the sanitized cwd path and stored in stdpath("state").
-- Auto-saved on every exit; <leader>qs restores the session for the current dir.
require("mini.sessions").setup({
  autoread  = false,
  autowrite = false,
  directory = vim.fn.stdpath("state") .. "/sessions",
})

local function _cwd_session_name()
  return (vim.fn.getcwd():gsub("[/\\: ]", "%%"))
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group    = vim.api.nvim_create_augroup("mini_sessions_autosave", { clear = true }),
  callback = function()
    if vim.g.mini_sessions_skip_save ~= true then
      MiniSessions.write(_cwd_session_name(), { force = true })
    end
  end,
})

-- <leader>qs  restore session for current directory
-- <leader>ql  pick from all saved sessions (UI picker)
-- <leader>qd  don't save session when exiting this time
vim.keymap.set("n", "<leader>qs", function()
  MiniSessions.read(_cwd_session_name())
end, { desc = "Session: restore current dir" })
vim.keymap.set("n", "<leader>ql", function()
  MiniSessions.select("read")
end, { desc = "Session: select + restore" })
vim.keymap.set("n", "<leader>qd", function()
  vim.g.mini_sessions_skip_save = true
  vim.notify("Session: won't be saved on exit", vim.log.levels.INFO)
end, { desc = "Session: skip save" })

-- ── Split/join expressions (gS) ──────────────────────────────────────────────
-- gS on a single-line call → expands args to multiple lines; on multi-line → joins
require("mini.splitjoin").setup({
  mappings = { toggle = "gS", split = "", join = "" },
})

-- ── Bracket navigation ([/] pairs for buffers, files, hunks, etc.) ───────────
-- Disable 'c' (conflicts with gitsigns ]c/[c) and 'f' (conflicts with treesitter ]f/[f)
require("mini.bracketed").setup({
  buffer     = { suffix = "b" },
  comment    = { suffix = "x" },
  conflict   = { suffix = "c", options = {} },   -- kept; gitsigns uses ]c in buffer-local maps
  diagnostic = { suffix = "d" },
  file       = { suffix = "" },                  -- disabled: conflicts with treesitter ]f/[f
  indent     = { suffix = "i" },
  jump       = { suffix = "j" },
  location   = { suffix = "l" },
  oldfile    = { suffix = "o" },
  quickfix   = { suffix = "q" },
  treesitter = { suffix = "t" },
  undo       = { suffix = "u" },
  window     = { suffix = "w" },
  yank       = { suffix = "y" },
})

-- ── Trailing whitespace (highlight + trim on save) ───────────────────────────
require("mini.trailspace").setup()
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = vim.api.nvim_create_augroup("mini_trailspace_trim", { clear = true }),
  callback = function()
    -- Skip special buffers (nofile, terminal, etc.)
    if vim.bo.buftype == "" then
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end
  end,
})

-- ── Frecency-based file visits (<leader>fv) ──────────────────────────────────
-- Tracks file opens; <leader>fv picks from recent files for the cwd.
require("mini.visits").setup()
vim.keymap.set("n", "<leader>fv", function()
  MiniVisits.select_path(nil, { filter = MiniVisits.gen_filter.this_session() })
end, { desc = "Find: visited files (session)" })
vim.keymap.set("n", "<leader>fV", function()
  MiniVisits.select_path()
end, { desc = "Find: visited files (all time)" })
