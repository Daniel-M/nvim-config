-- lsp/ruff.lua — Python Linting & Formatting (Ruff)
-- Install: pip install ruff   OR   uv add --dev ruff
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml", "setup.py", "setup.cfg",
    "requirements.txt", ".git",
  },
  init_options = {
    settings = {
      -- Any custom settings for the ruff server can go here
    },
  },
}
