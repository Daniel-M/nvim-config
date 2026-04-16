-- lua/plugins/markdown.lua
-- render-markdown.nvim: renders headings, code fences, tables, checkboxes inline.
-- Toggle at any time with :RenderMarkdown toggle
require("render-markdown").setup({
  enabled      = true,
  file_types   = { "markdown", "codecompanion" },
  render_modes = { "n", "c" },
  heading      = { enabled = true },
  code         = { enabled = true, style = "full" },
  bullet       = { enabled = true },
  checkbox     = { enabled = true },
  table        = { enabled = true },
})
