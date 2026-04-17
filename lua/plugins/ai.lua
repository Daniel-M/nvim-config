-- lua/plugins/ai.lua
-- codecompanion.nvim: AI chat panel backed by Anthropic (Claude).
-- Requires ANTHROPIC_API_KEY in the shell environment.
-- windsurf.nvim (Exafunction): AI ghost-text completions.

-- ── codecompanion ────────────────────────────────────────────────────────────
-- Requires ANTHROPIC_API_KEY (separate from Claude Code subscription).
-- Get a key at console.anthropic.com, then add to ~/.zshrc:
--   export ANTHROPIC_API_KEY="sk-ant-..."
require("codecompanion").setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        schema = { model = { default = "claude-sonnet-4-6" } },
      })
    end,
  },
  strategies = {
    chat   = { adapter = "anthropic" },
    inline = { adapter = "anthropic" },
    agent  = { adapter = "anthropic" },
  },
  display = {
    chat = { window = { layout = "vertical", width = 0.35 } },
  },
})

-- <leader>cc  toggle chat panel
-- <leader>aa  action picker (prompt library, slash commands)
-- <leader>ai  inline code edit (visual selection → prompt)
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>",
  { desc = "AI: codecompanion chat" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>",
  { desc = "AI: actions" })
vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanion<CR>",
  { desc = "AI: inline edit" })

-- ── windsurf (ghost-text) ─────────────────────────────────────────────────────
-- windsurf.nvim ships its Lua as the "codeium" module internally.
-- First use: run :Codeium Auth  to authenticate.
-- Uses Alt-l/Alt-w/Alt-e so that Tab stays free for blink.cmp.
require("codeium").setup({
  enable_cmp_source = false,   -- this config uses blink.cmp, not nvim-cmp
  virtual_text = {
    enabled     = true,
    map_keys    = true,
    key_bindings = {
      accept      = "<Tab>",    -- Tab: accept full suggestion (falls through from blink.cmp)
      accept_word = "<M-w>",   -- Alt-w: accept one word
      accept_line = false,
      clear       = "<M-e>",   -- Alt-e: dismiss
      next        = "<M-n>",
      prev        = "<M-p>",
    },
  },
})
