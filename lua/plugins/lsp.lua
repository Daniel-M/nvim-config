-- lua/plugins/lsp.lua
-- Uses Neovim 0.11+ native LSP API.
-- Server configs live in lsp/*.lua at the config root.
-- Enable each server here; Neovim auto-attaches on matching filetypes.

vim.lsp.enable({
  "ts_ls",
  "pyright",
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
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- Buffer-local keymaps and settings on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_maps", { clear = true }),
  callback = function(ev)
    local buf = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    -- Navigation
    map("n", "gd",         vim.lsp.buf.definition,       "LSP: Go to definition")
    map("n", "gD",         vim.lsp.buf.declaration,      "LSP: Go to declaration")
    map("n", "gi",         vim.lsp.buf.implementation,   "LSP: Go to implementation")
    map("n", "gy",         vim.lsp.buf.type_definition,  "LSP: Go to type definition")
    map("n", "gr",         vim.lsp.buf.references,       "LSP: References")
    map("n", "gK",         vim.lsp.buf.signature_help,   "LSP: Signature help")

    -- Hover documentation
    map("n", "K",          vim.lsp.buf.hover,            "LSP: Hover docs")

    -- Refactoring
    map("n", "<leader>rn", vim.lsp.buf.rename,           "LSP: Rename symbol")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")

    -- Format
    map({ "n", "x" }, "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: Format buffer")

    -- Diagnostics
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
    -- Leader alternatives (Spanish Mac: ]d/[d require Option key)
    map("n", "<leader>ep", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    map("n", "<leader>en", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
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

    -- Format on save for Go (gofmt is canonical)
    if client and client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buf,
        group = vim.api.nvim_create_augroup("gopls_format_" .. buf, { clear = true }),
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})
