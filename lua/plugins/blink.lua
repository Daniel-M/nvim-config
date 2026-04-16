-- lua/plugins/blink.lua
-- blink.cmp v1 — fast async completion with LSP, snippets, ghost text.

require("blink.cmp").setup({
  -- Download prebuilt Rust binary from GitHub (no cargo needed).
  -- force_version pins to v1.* tags to match the stable branch.
  fuzzy = {
    prebuilt_binaries = {
      download = true,
      force_version = "v1.*",
    },
  },

  -- Keymap preset: <C-space> trigger, <CR> confirm, <C-e> cancel
  -- <Tab>/<S-Tab> select next/prev, <C-b>/<C-f> scroll docs
  keymap = {
    preset = "default",
    ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"]    = { "accept", "fallback" },
    ["<C-e>"]   = { "cancel" },
    ["<C-b>"]   = { "scroll_documentation_up", "fallback" },
    ["<C-f>"]   = { "scroll_documentation_down", "fallback" },
  },

  -- Use mini.snippets for snippet expansion
  snippets = { preset = "mini_snippets" },

  -- Completion behavior
  completion = {
    -- Show documentation popup automatically
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "rounded" },
    },
    -- Ghost text (inline preview of first suggestion)
    ghost_text = { enabled = true },
    -- Menu appearance
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
          { "source_name" },
        },
      },
    },
    list = {
      selection = { preselect = true, auto_insert = true },
    },
  },

  -- Signature help (shows function signature as you type arguments)
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },

  -- Completion sources
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      lsp     = { name = "LSP",     score_offset = 5 },
      path    = { name = "Path",    score_offset = 3 },
      snippets = { name = "Snippet", score_offset = 4 },
      buffer  = { name = "Buffer",  score_offset = 0, max_items = 5 },
    },
  },

  -- Appearance
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
    kind_icons = {
      Text          = "󰉿",
      Method        = "󰆧",
      Function      = "󰊕",
      Constructor   = "",
      Field         = "󰜢",
      Variable      = "󰀫",
      Class         = "󰠱",
      Interface     = "",
      Module        = "",
      Property      = "󰜢",
      Unit          = "󰑭",
      Value         = "󰎠",
      Enum          = "",
      Keyword       = "󰌋",
      Snippet       = "",
      Color         = "󰏘",
      File          = "󰈙",
      Reference     = "󰈇",
      Folder        = "󰉋",
      EnumMember    = "",
      Constant      = "󰏿",
      Struct        = "󰙅",
      Event         = "",
      Operator      = "󰆕",
      TypeParameter = "",
    },
  },
})
