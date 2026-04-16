-- lsp/jsonls.lua — JSON Language Server
-- Install: npm install -g vscode-langservers-extracted
return {
  cmd        = { "vscode-json-language-server", "--stdio" },
  filetypes  = { "json", "jsonc" },
  root_markers = { ".git" },
  settings = {
    json = {
      schemas  = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
  init_options = {
    provideFormatter = true,
  },
}
