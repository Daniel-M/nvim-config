-- lua/plugins/lang/go.lua
require("go").setup({
  go      = "go",
  goimport = "gopls",
  gofmt   = "gofumpt",          -- stricter gofmt; install: go install mvdan.cc/gofumpt@latest
  max_line_len = 120,
  tag_transform = false,
  test_dir = "",
  comment_placeholder = "   ",
  lsp_cfg = false,              -- we configure gopls via lsp/gopls.lua
  lsp_gofumpt = true,
  lsp_on_attach = false,        -- handled in plugins/lsp.lua LspAttach
  lsp_codelens = true,
  lsp_keymaps = false,          -- handled in plugins/lsp.lua
  lsp_diag_hdlr = false,        -- handled globally
  lsp_inlay_hints = {
    enable = true,
    style = "inlay",
  },
  dap_debug = true,
  dap_debug_keymap = false,
  dap_debug_gui = false,
  dap_debug_vt = false,
  build_tags = "",
  textobjects = false,          -- we use nvim-treesitter-textobjects
  test_runner = "go",
  verbose_tests = true,
  run_in_floaterm = false,
  luasnip = false,              -- we use mini.snippets via blink.cmp
  trouble = false,
})

-- Format on save (also handled in lsp.lua for gopls, but go.nvim provides gofumpt)
local go_grp = vim.api.nvim_create_augroup("go_nvim_format", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = go_grp,
  pattern = "*.go",
  callback = function()
    require("go.format").gofmt()
  end,
})

-- Go-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("go_keymaps", { clear = true }),
  pattern = "go",
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("<leader>gr",  "<cmd>GoRun<CR>",          "Go: run")
    map("<leader>gt",  "<cmd>GoTest<CR>",          "Go: test")
    map("<leader>gtf", "<cmd>GoTestFunc<CR>",      "Go: test function")
    map("<leader>gtc", "<cmd>GoCoverage<CR>",      "Go: coverage")
    map("<leader>ga",  "<cmd>GoAlt!<CR>",          "Go: alternate file")
    map("<leader>gai", "<cmd>GoAddTag<CR>",        "Go: add struct tags")
    map("<leader>gri", "<cmd>GoRemoveTags<CR>",    "Go: remove struct tags")
    map("<leader>gfs", "<cmd>GoFillStruct<CR>",    "Go: fill struct")
    map("<leader>gfe", "<cmd>GoFillSwitch<CR>",    "Go: fill switch")
    map("<leader>gie", "<cmd>GoIfErr<CR>",         "Go: if err != nil")
    map("<leader>gl",  "<cmd>GoLint<CR>",          "Go: lint")
    map("<leader>gI",  "<cmd>GoImpl<CR>",          "Go: implement interface")
  end,
})
