-- lsp/lua_ls.lua — Lua Language Server (for editing this config)
-- Install: brew install lua-language-server
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("data") .. "/lazy",  -- if ever switching to lazy
        },
      },
      diagnostics = {
        globals = { "vim", "MiniStatusline", "MiniFiles", "MiniGit",
                    "MiniDiff", "MiniNotify", "MiniClue", "MiniIndentscope",
                    "MiniBufremove", "MiniIcons" },
      },
      completion  = { callSnippet = "Replace" },
      telemetry   = { enable = false },
      hint        = { enable = true },
    },
  },
}
