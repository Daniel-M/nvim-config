---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local local_bin = root .. "/node_modules/.bin/oxlint"
    local cmd = vim.fn.executable(local_bin) == 1 and local_bin or "oxlint"
    return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
  end,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { ".oxlintrc.json", "oxlint.config.ts", "package.json", ".git" },
}
