-- lsp/yamlls.lua — YAML Language Server
-- Install: npm install -g yaml-language-server
return {
  cmd        = { "yaml-language-server", "--stdio" },
  filetypes  = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },  -- disable built-in store; use SchemaStore.nvim
      schemas     = require("schemastore").yaml.schemas(),
      validate    = true,
      format      = { enable = true },
    },
  },
}
