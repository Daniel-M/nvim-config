-- lua/plugins/colorscheme.lua
require("catppuccin").setup({
  flavour      = "mocha",   -- latte | frappe | macchiato | mocha
  background   = { light = "latte", dark = "mocha" },
  transparent_background = false,
  term_colors  = true,
  integrations = {
    treesitter        = true,
    native_lsp        = {
      enabled         = true,
      underlines      = { errors = { "underline" }, warnings = { "underline" } },
    },
    blink_cmp         = true,
    mini              = { enabled = true },
    gitsigns          = true,
    telescope         = { enabled = true },
    which_key         = false,
    render_markdown   = true,
    trouble           = true,
  },
})

vim.cmd.colorscheme("catppuccin-mocha")

-- onenord available:  vim.cmd.colorscheme("onenord")
-- tokyonight:         vim.cmd.colorscheme("tokyonight-night")
