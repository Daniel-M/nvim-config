-- lua/plugins/lint.lua
-- nvim-lint: asynchronous linter integration
local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
}

local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

-- Only run external linters on file save (BufWritePost) or initial buffer load (BufEnter)
-- External linters (like golangci-lint) inspect disk contents, so running them on InsertLeave
-- on modified buffers re-populates stale errors from disk before saving.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Clear external linter diagnostics when buffer is edited so stale disk diagnostics disappear while typing
vim.api.nvim_create_autocmd({ "TextChanged", "InsertEnter" }, {
  group = lint_augroup,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local linters = lint.linters_by_ft[ft]
    if linters then
      for _, linter_name in ipairs(linters) do
        local ns = lint.get_namespace(linter_name)
        if ns then
          vim.diagnostic.reset(ns, ev.buf)
        end
      end
    end
  end,
})

