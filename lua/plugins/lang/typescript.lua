-- lua/plugins/lang/typescript.lua

-- Async project-wide TypeScript type checking
require("tsc").setup({
  auto_open_qflist = true,
  auto_close_qflist = false,
  auto_focus_qflist = false,
  auto_start_watch_mode = true,     -- watch for changes + show diagnostics
  use_trouble_qflist = false,
  spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  pretty_errors = true,
})

-- Human-readable TypeScript errors (replaces cryptic TS messages)
require("ts-error-translator").setup({
  auto_attach = true,
})

-- ── Organize imports on save (vtsls) ─────────────────────────────────────────
-- Requests only source.organizeImports for the whole document. Asking for the
-- kind explicitly matters: the unfiltered <leader>ca menu doesn't include it.
-- Synchronous, so the edit is applied before the buffer is written.
local function organize_imports(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
  if not client then return end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = line_count, character = 0 },
    },
    context = { only = { "source.organizeImports" }, diagnostics = {} },
  }

  local res = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
  for _, action in ipairs(res and res.result or {}) do
    if not action.edit and not action.command then
      -- Some servers only return the edit after resolve
      local resolved = client:request_sync("codeAction/resolve", action, 1000, bufnr)
      action = resolved and resolved.result or action
    end
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    -- _typescript.* commands are client-side hooks (VS Code's TS extension
    -- handles them); vtsls doesn't implement them, so don't send them.
    local cmd = action.command
    if cmd and not (type(cmd) == "table" and cmd.command and cmd.command:match("^_typescript%.")) then
      client:exec_cmd(cmd, { bufnr = bufnr })
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ts_organize_imports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.mts", "*.cts", "*.js", "*.jsx", "*.mjs", "*.cjs" },
  callback = function(ev) organize_imports(ev.buf) end,
})

-- Keymaps (only active in TS/JS files via ftplugin would be cleaner,
-- but top-level is fine for a global <leader>tt binding)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function(ev)
    vim.keymap.set("n", "<leader>tt", "<cmd>TSC<CR>",
      { buffer = ev.buf, desc = "TypeScript: type check" })
    vim.keymap.set("n", "<leader>tw", "<cmd>TSCWatch<CR>",
      { buffer = ev.buf, desc = "TypeScript: watch mode" })
    vim.keymap.set("n", "<leader>tT", "<cmd>TSCStop<CR>",
      { buffer = ev.buf, desc = "TypeScript: stop check" })
  end,
})

-- ── package-info.nvim ────────────────────────────────────────────────────────
-- Virtual text showing latest npm version next to each dep in package.json.
require("package-info").setup({
  highlights = {
    up_to_date = { fg = "#3C4048" },
    outdated   = { fg = "#d19a66" },
  },
  icons    = { enable = true, style = { up_to_date = "| ", outdated = "| " } },
  autostart              = true,
  hide_up_to_date        = true,
  hide_unstable_versions = false,
})

-- <leader>np  toggle version display
-- <leader>nu  update package under cursor
-- <leader>nd  delete package under cursor
-- <leader>ni  install new package
vim.keymap.set("n", "<leader>np", function() require("package-info").toggle()  end,
  { desc = "npm: toggle version display" })
vim.keymap.set("n", "<leader>nu", function() require("package-info").update()  end,
  { desc = "npm: update package" })
vim.keymap.set("n", "<leader>nd", function() require("package-info").delete()  end,
  { desc = "npm: delete package" })
vim.keymap.set("n", "<leader>ni", function() require("package-info").install() end,
  { desc = "npm: install new package" })
