-- lsp/ts_ls.lua — TypeScript Language Server
-- Install: npm install -g typescript-language-server typescript
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript", "typescriptreact",
    "javascript", "javascriptreact",
    "typescript.tsx", "javascript.jsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints        = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints         = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints      = true,
      },
      suggest = {
        completeUnimported = true,
        includeCompletionsFromDelay = false,
      },
      preferences = {
        importModuleSpecifier = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints        = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints         = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints      = true,
      },
    },
  },
}
