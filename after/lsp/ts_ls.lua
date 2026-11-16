-- lsp/ts_ls.lua — TypeScript Language Server
-- Install: npm install -g typescript-language-server typescript
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local local_bin = root .. "/node_modules/.bin/typescript-language-server"
    local cmd = vim.fn.executable(local_bin) == 1 and local_bin or "typescript-language-server"
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end,
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "typescript.tsx",
    "javascript.jsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = {
    hostInfo = "neovim",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
      preferences = {
        importModuleSpecifier = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
      preferences = {
        importModuleSpecifier = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
  },
}
