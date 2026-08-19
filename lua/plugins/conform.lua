-- lua/plugins/conform.lua
-- conform.nvim: per-filetype formatters with LSP fallback.
--
-- <leader>F  → format via conform (falls back to LSP if no formatter found)
-- <leader>f  → LSP-native format only (from lsp.lua)
--
-- Required external tools (install once):
--   npm i -g @fsouza/prettierd        (faster prettier daemon)
--   uv add --dev ruff
--   go install mvdan.cc/gofumpt@latest
--   go install golang.org/x/tools/cmd/goimports@latest
--   brew install stylua

require("conform").setup({
  formatters_by_ft = {
    typescript      = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    ts              = { "prettierd", "prettier", stop_after_first = true },
    tsx             = { "prettierd", "prettier", stop_after_first = true },
    javascript      = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    json            = { "prettierd", "prettier", stop_after_first = true },
    jsonc           = { "prettierd", "prettier", stop_after_first = true },
    yaml            = { "prettierd", "prettier", stop_after_first = true },
    markdown        = { "prettierd", "prettier", stop_after_first = true },
    graphql         = { "prettierd", "prettier", stop_after_first = true },
    html            = { "prettierd", "prettier", stop_after_first = true },
    css             = { "prettierd", "prettier", stop_after_first = true },
    python          = { "ruff_organize_imports", "ruff_format" },
    go              = { "gofumpt", "goimports" },
    lua             = { "stylua" },
    terraform       = { "terraform_fmt" },
  },
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if vim.tbl_contains({ "typescript", "typescriptreact", "ts", "tsx", "javascript", "javascriptreact" }, ft) then
      return { timeout_ms = 500, lsp_fallback = true }
    end
  end,
  default_format_opts = { lsp_format = "fallback" },
  notify_on_error = true,
})

vim.keymap.set({ "n", "x" }, "<leader>F", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format (conform)" })
