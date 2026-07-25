-- lua/plugins/claudecode.lua
-- claudecode.nvim: Claude Code sidebar using the same WebSocket protocol as
-- the official VS Code extension. Uses your existing `claude login` auth —
-- no API key needed.
require("claudecode").setup({
  auto_start   = true,
  log_level    = "warn",
  terminal_cmd = "claude",    -- path to the claude CLI

  track_selection = true,     -- send cursor/selection context in real time

  terminal = {
    split_side             = "right",
    split_width_percentage = 0.35,
    provider               = "native",
    auto_close             = true,
  },

  diff = {
    layout           = "vertical",
    open_in_new_tab  = false,
  },
})

-- <leader>cc  toggle sidebar (primary Claude entry point)
-- <leader>cf  focus/unfocus sidebar
-- <leader>cs  send visual selection to Claude
-- <leader>cb  add current buffer to Claude context
-- <leader>cy  accept diff
-- <leader>cn  deny diff
-- Custom command ClaudeCode is provided by the claudecode plugin to open the sidebar.
-- <leader>cc mapping has been removed in favor of comments.
vim.keymap.set("n",        "<leader>cf", "<cmd>ClaudeCodeFocus<CR>",
  { desc = "Claude: focus sidebar" })
vim.keymap.set("v",        "<leader>cs", "<cmd>ClaudeCodeSend<CR>",
  { desc = "Claude: send selection" })
vim.keymap.set("n",        "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>",
  { desc = "Claude: add buffer to context" })
vim.keymap.set("n",        "<leader>cy", "<cmd>ClaudeCodeDiffAccept<CR>",
  { desc = "Claude: accept diff" })
vim.keymap.set("n",        "<leader>cn", "<cmd>ClaudeCodeDiffDeny<CR>",
  { desc = "Claude: deny diff" })
