-- lua/plugins/lang/python.lua

-- Virtual environment switcher
require("swenv").setup({
  -- Automatically activate the venv when opening a Python file
  -- if a venv is found in the project root
  auto_create_autocmd = true,
  -- Where to look for venvs (relative to cwd)
  get_envs = function()
    return require("swenv.api").get_envs()
  end,
  post_set_venv = function()
    -- Restart LSP after switching venv so pyright picks up the new interpreter
    vim.cmd("LspRestart")
  end,
})

-- Keymaps for Python files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("python_keymaps", { clear = true }),
  pattern = "python",
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("<leader>pv", "<cmd>lua require('swenv.api').pick_venv()<CR>", "Python: pick venv")
    map("<leader>pV", "<cmd>lua require('swenv.api').get_current_venv()<CR>", "Python: current venv")
  end,
})
