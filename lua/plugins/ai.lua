-- lua/plugins/ai.lua
-- codecompanion.nvim: AI chat panel backed by Anthropic (Claude).
-- Requires ANTHROPIC_API_KEY in the shell environment.
-- Ghost-text completions come from blink.cmp (see blink.lua).

-- ── codecompanion ────────────────────────────────────────────────────────────
-- Requires ANTHROPIC_API_KEY (separate from Claude Code subscription).
-- Get a key at console.anthropic.com, then add to ~/.zshrc:
--   export ANTHROPIC_API_KEY="sk-ant-..."
require("codecompanion").setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        schema = { model = { default = "claude-haiku-5-5" } },
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

-- <leader>ac  toggle chat panel
-- <leader>aa  action picker (prompt library, slash commands)
-- <leader>ai  inline code edit (visual selection → prompt)
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>",
  { desc = "AI: codecompanion chat" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>",
  { desc = "AI: actions" })
vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanion<CR>",
  { desc = "AI: inline edit" })
