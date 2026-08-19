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
