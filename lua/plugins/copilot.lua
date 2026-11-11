-- lua/plugins/copilot.lua
-- copilot.lua: GitHub Copilot client. Suggestions reach the completion menu through
-- blink-cmp-copilot (configured in blink.lua).
-- The inline suggestion module and the panel are disabled so Copilot doesn't draw
-- ghost text that clashes with blink's menu.
-- First use: run :Copilot auth and sign in with a GitHub account that has Copilot.

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = { ["*"] = true },
})
