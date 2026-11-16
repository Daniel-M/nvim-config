-- lsp/vtsls.lua — Vtsls TypeScript Language Server
-- Install: npm install -g @vtsls/language-server
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local local_bin = root .. "/node_modules/.bin/vtsls"
    local cmd = vim.fn.executable(local_bin) == 1 and local_bin or "vtsls"
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
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        completeFunctionCalls = true,
      },
      preferences = {
        importModuleSpecifier = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        completeFunctionCalls = true,
      },
      preferences = {
        importModuleSpecifier = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
  },
}
