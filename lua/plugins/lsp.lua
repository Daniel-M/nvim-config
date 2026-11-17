-- lua/plugins/lsp.lua
-- Uses Neovim 0.11+ native LSP API.
-- Server configs live in lsp/*.lua at the config root.
-- Enable each server here; Neovim auto-attaches on matching filetypes.

vim.lsp.enable({
  -- "ts_ls",
  "vtsls",
  "oxlint",
  "eslint",
  "pyright",
  "ruff",
  "gopls",
  "lua_ls",
  "terraformls",
  "marksman",
  -- JSON/YAML with SchemaStore schemas (install: npm i -g vscode-langservers-extracted yaml-language-server)
  "jsonls",
  "yamlls",
})

-- Diagnostic display
vim.diagnostic.config({
  -- NOTE: virtual text runs out of the window
  -- virtual_text = {
  --   spacing = 4,
  --   source = "if_many",
  --   prefix = "●",
  -- },
  virtual_text = false,
  virtual_lines = {
    current_line = true
  },
  signs = {
    text = {
      -- [vim.diagnostic.severity.ERROR] = " ",
      -- [vim.diagnostic.severity.WARN]  = " ",
      -- [vim.diagnostic.severity.HINT]  = " ",
      -- [vim.diagnostic.severity.INFO]  = " ",
      [vim.diagnostic.severity.ERROR] = "\u{ea87} ", --  (nf-cod-error)
      [vim.diagnostic.severity.WARN]  = "\u{ea6c} ", --  (nf-cod-warning)
      [vim.diagnostic.severity.HINT]  = "\u{f400} ", --  (nf-oct-light_bulb)
      [vim.diagnostic.severity.INFO]  = "\u{ea74} ", --  (nf-cod-info)
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  -- Text should be wrapped
  float = { border = "rounded", source = true, wrap = true, max_width = 80 },
})

-- Diagnostics as notifications
-- Ensure mini.notify is active (if not already initialized in your mini.nvim setup)
if package.loaded["mini.notify"] or pcall(require, "mini.notify") then
  local notify = require("mini.notify")
  if not _G.MiniNotify then
    notify.setup()
    vim.notify = notify.make_notify()
  end
end

-- Forward new/changed diagnostics to top-right notifications
local diag_notify_group = vim.api.nvim_create_augroup("DiagnosticNotifications", { clear = true })
local last_notified = {}

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = diag_notify_group,
  callback = function(ev)
    -- Skip while actively typing in insert mode
    if vim.fn.mode():match("^[iR]") then
      return
    end

    local diagnostics = ev.data.diagnostics or {}
    if #diagnostics == 0 then
      last_notified[ev.buf] = nil
      return
    end

    -- Filter to ERROR and WARN only (change to HINT/INFO if you want everything)
    local important = vim.tbl_filter(function(d)
      return d.severity <= vim.diagnostic.severity.WARN
    end, diagnostics)

    if #important == 0 then
      return
    end

    -- Sort by severity (errors first), then line number
    table.sort(important, function(a, b)
      if a.severity ~= b.severity then
        return a.severity < b.severity
      end
      return a.lnum < b.lnum
    end)

    local top = important[1]
    local level = top.severity == vim.diagnostic.severity.ERROR
        and vim.log.levels.ERROR
      or vim.log.levels.WARN

    local source = top.source and ("[" .. top.source .. "] ") or ""
    local extra = #important > 1 and string.format(" (+%d more)", #important - 1) or ""
    local msg = string.format("%sLine %d: %s%s", source, top.lnum + 1, top.message, extra)

    -- Avoid spamming identical notifications on cursor moves / redraws
    if last_notified[ev.buf] == msg then
      return
    end
    last_notified[ev.buf] = msg

    vim.notify(msg, level)
  end,
})

-- Buffer-local keymaps and settings on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_maps", { clear = true }),
  callback = function(ev)
    local buf = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Disable Ruff hover in favor of Pyright (avoid duplicate hover windows)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    -- Navigation
    map("n", "gd",         function() vim.lsp.buf.definition({ border = "rounded" }) end, "LSP: Go to definition")
    map("n", "gD",         vim.lsp.buf.declaration,      "LSP: Go to declaration")
    map("n", "gi",         vim.lsp.buf.implementation,   "LSP: Go to implementation")
    map("n", "gy",         vim.lsp.buf.type_definition,  "LSP: Go to type definition")
    map("n", "gr",         function() vim.lsp.buf.references({ border = "rounded" }) end, "LSP: References")
    map("n", "gK",         vim.lsp.buf.signature_help,   "LSP: Signature help")

    -- Hover documentation
    map("n", "K",          vim.lsp.buf.hover,            "LSP: Hover docs")

    -- Refactoring
    map("n", "<leader>rn", vim.lsp.buf.rename,           "LSP: Rename symbol")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")

    -- Format
    map({ "n", "x" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: Format buffer")

    -- Diagnostics
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
    -- Leader alternatives (Spanish Mac: ]d/[d require Option key)
    map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
    map("n", "<leader>ld", vim.diagnostic.open_float,    "LSP: Line diagnostics")
    map("n", "<leader>lD", vim.diagnostic.setloclist,    "LSP: Diagnostics list")

    -- Workspace
    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    "LSP: Add workspace folder")
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "LSP: Remove workspace folder")
    map("n", "<leader>lwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "LSP: List workspace folders")

    -- Inlay hints toggle (Neovim 0.10+)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      map("n", "<leader>lh", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
          { bufnr = buf }
        )
      end, "LSP: Toggle inlay hints")
    end

    -- Document highlight (highlight all occurrences on cursor hold)
    if client and client:supports_method("textDocument/documentHighlight") then
      local grp = vim.api.nvim_create_augroup("lsp_document_highlight_" .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf, group = grp,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf, group = grp,
        callback = vim.lsp.buf.clear_references,
      })
    end


  end,
})
