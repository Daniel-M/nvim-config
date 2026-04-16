-- lua/plugins/colorizer.lua
-- catgoose/nvim-colorizer.lua: maintained fork, updated for Neovim 0.12+.
-- Inline color swatches for hex codes, rgb(), hsl(), and Tailwind class names.

require("colorizer").setup({
  filetypes = {
    "css", "scss", "sass",
    "html",
    "javascript", "typescript",
    "typescriptreact", "javascriptreact",
    "vue",
    "lua",
    "yaml", "toml",
    "terraform",
  },
  user_commands = true,  -- registers :ColorizerToggle etc.
  -- per-filetype options override; leave empty to use global defaults below
  filetypes_options = {},
  -- global defaults applied to all filetypes listed above
  default_options = {
    hex        = true,   -- #RGB and #RRGGBB
    rgb        = true,   -- rgb() / rgba()
    hsl        = true,   -- hsl() / hsla()
    names      = false,  -- color names like "blue" — off to reduce noise
    tailwind   = {
      enable       = true,
      update_names = true,
    },
    mode = "background",  -- "background" | "foreground" | "underline" | "virtualtext"
  },
})
