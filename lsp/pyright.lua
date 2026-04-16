-- lsp/pyright.lua — Python (Pyright)
-- Install: pip install pyright   OR   npm install -g pyright
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml", "setup.py", "setup.cfg",
    "requirements.txt", ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths        = true,
        useLibraryCodeForTypes = true,
        diagnosticMode         = "openFilesOnly",  -- "workspace" for stricter
        typeCheckingMode       = "basic",           -- "off" | "basic" | "standard" | "strict"
        inlayHints = {
          variableTypes          = true,
          functionReturnTypes    = true,
          callArgumentNames      = true,
          pytestParameters       = true,
        },
      },
    },
  },
}
