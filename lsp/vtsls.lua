-- ~/.config/nvim/after/lsp/vtsls.lua
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local local_bin = root .. "/node_modules/.bin/vtsls"
    local cmd = vim.fn.executable(local_bin) == 1 and local_bin or "vtsls"
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end,
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
