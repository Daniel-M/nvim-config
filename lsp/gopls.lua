-- lsp/gopls.lua — Go Language Server
-- Install: brew install gopls   OR   go install golang.org/x/tools/gopls@latest
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams  = true,
        shadow        = true,
        nilness       = true,
        unusedwrite   = true,
        useany        = true,
      },
      staticcheck    = true,
      gofumpt        = true,
      usePlaceholders = true,
      completeUnimported = true,
      diagnosticsDelay = "250ms",
      directoryFilters = { "-**/node_modules", "-**/.git" },
      hints = {
        assignVariableTypes    = true,
        compositeLiteralFields  = true,
        compositeLiteralTypes   = true,
        constantValues         = true,
        functionTypeParameters  = true,
        parameterNames         = true,
        rangeVariableTypes     = true,
      },
    },
  },
}
