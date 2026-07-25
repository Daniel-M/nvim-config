# 💤 Custom Neovim Configuration (vim.pack)

A custom, fast, and feature-rich Neovim configuration built from scratch (updated April/July 2026). It uses Neovim's built-in package manager (`vim.pack`) rather than external ones like Lazy, leverages `mini.nvim` for UI/editing components, and includes native LSP configurations, advanced completions, fuzzy finding, project search/replace, bookmarks, and state-of-the-art AI pair programming tools.

Designed for Neovim **0.12.1+** on macOS (Apple Silicon).

---

## 📂 Directory Layout

```
~/.config/nvim/
├── init.lua                        # Entry point — explicit load order
├── README.md                       # This unified guide & reference manual
├── SETUP.md                        # Detailed design decisions, logs, & error resolutions
├── nvim-pack-lock.json             # Locked plugin commits managed by vim.pack
├── snippets/
│   └── global.json                 # Custom global VSCode-format snippets
├── lsp/                            # Native LSP server definitions (no Mason overhead)
│   ├── ts_ls.lua                   # TypeScript / JavaScript
│   ├── pyright.lua                 # Python
│   ├── ruff.lua                    # Python Linting/Formatting (Ruff)
│   ├── gopls.lua                   # Go
│   ├── lua_ls.lua                  # Lua (self-editing)
│   ├── terraformls.lua             # Terraform
│   ├── marksman.lua                # Markdown
│   ├── jsonls.lua                  # JSON (uses SchemaStore)
│   └── yamlls.lua                  # YAML (uses SchemaStore)
└── lua/
    ├── options.lua                 # vim.opt settings (relative line numbers, formatting rules)
    ├── keymaps.lua                 # Global hotkeys (Leader = Space)
    ├── autocmds.lua                # Event-based logic (yank highlight, trim whitespace, auto-dirs)
    └── plugins/
        ├── pack.lua                # Plugin source registry (edit here to add/remove plugins)
        ├── colorscheme.lua         # Theme configs (Tokyo Night, OneNord, Catppuccin)
        ├── mini.lua                # mini.nvim modular configs (18 modules)
        ├── treesitter.lua          # nvim-treesitter 0.12+ API configurations
        ├── lsp.lua                 # LSP buffer attachments, keymaps, and diagnostics
        ├── blink.lua               # Fast completion engine configuration
        ├── telescope.lua           # Fuzzy finder settings
        ├── git.lua                 # Gitsigns hunk management and diffing
        ├── conform.lua             # Code formatting configuration
        ├── hlslens.lua             # Search match count overlays
        ├── colorizer.lua           # Inline hex/rgb/Tailwind color previews
        ├── markdown.lua            # Render Markdown styles inline
        ├── claudecode.lua          # Embedded Claude Code sidebar
        ├── ai.lua                  # CodeCompanion & Windsurf configuration
        ├── grug-far.lua            # Project-wide search and replace
        ├── harpoon.lua             # Harpoon2 quick-navigation bookmarks
        └── trouble.lua             # Diagnostics and symbols panels
        └── lang/
            ├── typescript.lua      # TypeScript-specific tools & package-info
            ├── go.lua              # Go.nvim tools
            └── python.lua          # Swenv Python environment picker
```

---

## 🛠️ Installation & Dependencies

### 1. Requirements

Before starting Neovim, install the following dependencies via Homebrew, Node, or Python to enable full functionality:

```bash
# Search & Compilation tools
brew install ripgrep tree-sitter-cli

# LSP Servers
npm install -g typescript-language-server typescript vscode-langservers-extracted yaml-language-server
pip install pyright ruff
brew install gopls lua-language-server hashicorp/tap/terraform-ls marksman

# Formatters
npm install -g @fsouza/prettierd stylua
pip install black isort
go install mvdan.cc/gofumpt@latest golang.org/x/tools/cmd/goimports@latest
```

### 2. Nerd Font
Ensure you have a Nerd Font (e.g., **Hurmit Nerd Font Mono** / Hermit Nerd Font) installed and set in your terminal emulator or Neovim GUI configurations.

### 3. Initialize & First Run

1. Clone or copy these configurations into `~/.config/nvim/`.
2. Start Neovim (`nvim`).
3. Run `:checkhealth vim.pack` to verify all plugins clone successfully.
4. Run `:TSUpdate` to compile Tree-sitter parsers.
5. Navigate to `~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim` and run `make` to compile the C-sorter logic.
6. Open any code file to confirm LSPs attach (run `:LspInfo`).

### 4. Updating Plugins

To update your plugins to their latest versions, run the custom user command inside Neovim:
```vim
:VimPackUpdatePlugins
```
*Alternatively, you can run the underlying Lua command: `:lua vim.pack.update()`. This runs asynchronously, downloads updates, and automatically updates the [nvim-pack-lock.json](file:///Users/danielmejiar./.config/nvim/nvim-pack-lock.json) lockfile.*

---

## 📖 Detailed Configuration Guide

### 1. Navigate Definitions, References, & Symbols

All LSP navigation activates automatically once a language server attaches.

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `gr` | List all references (quickfix) |
| `K` | Hover documentation (shows parameter details, types, etc.) |
| `gK` | Signature help (highlights arguments as you fill them) |
| `<leader>rn` | Rename symbol across the project (LSP-semantic) |
| `<leader>ca` | Code actions (extract, auto-fix, import, etc.) |
| `<C-o>` / `<C-i>` | Jump back / forward in jump list |

#### Fuzzy Finder Navigation (Telescope)
- `<leader>fs` - Document symbols (current file)
- `<leader>fS` - Workspace symbols (all files)
- `<leader>fi` - Go to implementations picker
- `<leader>fR` - Find references picker

#### Treesitter-based Structural Jumps
You can jump block-by-block using semantic nodes:
- `]f` / `[f` - Go to next / previous function start
- `]F` / `[F` - Go to next / previous function end
- `]C` / `[C` - Go to next / previous class start
- `]a` / `[a` - Go to next / previous parameter

---

### 2. Search & Replace

#### In-buffer Search
- `/pattern` and `?pattern` perform forward and backward searches.
- `n` and `N` cycle matches.
- `*` and `#` search the exact word under the cursor, while `g*` and `g#` search partial matches.
- **nvim-hlslens** shows an `[x/N]` match count overlay as virtual text next to matches as you navigate.
- Clear search highlights anytime with `<Esc>`.

#### Project-wide Search & Replace (Grug-far)
- `<leader>sr` (Normal/Visual) - Opens the **grug-far** panel (visual selection fills search field).
- `<leader>sw` - Opens **grug-far** pre-filled with the word under the cursor.
- Inside the panel: Edit the **Search** and **Replace** fields, and press `<CR>` (or mapped action key) to execute. The flags field accepts ripgrep flags (e.g. `--type ts`, `-g '!dist'`).

---

### 3. Finding Files

| Key | Action |
| --- | --- |
| `<leader><Space>` / `<C-p>` | **Smart file picker** — git-tracked files in a repo, all files outside |
| `<leader>ff` | All files (hidden included, respects `.gitignore`) |
| `<leader>fb` | List open buffers |
| `<leader>fr` | Recently opened files (`:oldfiles`) |
| `<leader>fv` | Visited files this session (frecency-based via `mini.visits`) |
| `<leader>fV` | Visited files of all time (frecency) |
| `<leader>fP` | Files in a specific directory (prompts for path) |

#### live_grep (ripgrep)
- `<leader>fg` - Live grep in CWD (updates as you type).
- `<leader>fw` - Grep word under cursor in CWD.
- `<leader>fD` - Live grep in specific directory (prompts for path).
- `<leader>fp` - Re-opens last Telescope picker with previous query.
- Type `<C-q>` in any Telescope file/grep window to send matches to the quickfix list.

---

### 4. Visual Selections, Text Objects, & Editing

#### Treesitter Text Objects
Select structure in visual or operator-pending mode:
- `af` / `if` - Outer / inner function (e.g. `vaf` selects function, `dif` deletes body)
- `ac` / `ic` - Outer / inner class
- `aa` / `ia` - Outer / inner parameter / argument
- `ab` / `ib` - Outer / inner block `{}`
- `al` / `il` - Outer / inner loop
- `ai` / `ii` - Outer / inner conditional

#### mini.ai Extended Objects
- `a"` / `i"` - Around / inside double quotes
- `a'` / `i'` - Around / inside single quotes
- `a(` / `i(` - Around / inside parentheses
- `a{` / `i{` - Around / inside braces
- `a[` / `i[` - Around / inside brackets
- `at` / `it` - Around / inside HTML tags

#### Editing Enhancements
- **Surround** (`mini.surround`):
  - `sa{motion}{char}` - Add surrounding (e.g., `saiw"` wraps word in `"`).
  - `sd{char}` - Delete surrounding.
  - `sr{old}{new}` - Replace surrounding.
  - In Visual mode: Highlight selection and press `sa"` to surround.
- **Move Lines** (`mini.move`): Press `<A-j>`/`<A-k>` in Visual mode to move selections up/down, or `<A-h>`/`<A-l>` to slide selections left/right.
- **Commenting** (`mini.comment`): `cc` or `gcc` comments the current line, `cc` or `gc` comments selection in Visual mode, and `gbc` applies block comments.
- **Split / Join Arguments** (`mini.splitjoin`): Press `gS` on any function call, array, or object literal to toggle between single-line and multiline formats.
- **Swap Parameters**: Press `<leader>sp` / `<leader>sP` to swap the current parameter with the next / previous one.
- **Auto-pairs** (`mini.pairs`): Automatically inserts matching brackets/quotes in Insert mode.
- **Colorizer** (`catgoose/nvim-colorizer.lua`): Automatically displays colored previews of CSS, JSX, Tailwind, Lua, and HCL hex/rgb codes.

---

### 5. Multi-file & Workspace Workflow

#### File Explorer (mini.files)
- `<leader>e` - Toggle file explorer.
- `<leader>E` - Open explorer focused on the current buffer's directory.
- *Inside explorer:* Navigate with `hjkl`. Press `a` to create, `r` to rename, `d` to delete. Run `:w` inside the explorer window to save changes.

#### Buffer & Window Management
- Buffer switches: `<S-h>` / `<S-l>` for previous / next buffer.
- Buffer delete: `<leader>bd` removes a buffer cleanly without breaking the window layout. Mapped to `<leader>bD` for force deletion.
- Split navigation: navigate splits seamlessly with `<C-h/j/k/l>`. Resize splits using `<C-Up/Down/Left/Right>`.

#### Bookmarks (Harpoon2)
Instantly save and hop to active files (up to 4 slots per project):
- `<leader>ma` - Add current file to Harpoon list.
- `<leader>mm` - Open the Harpoon menu to edit/reorder bookmarks.
- `<leader>m1` – `<leader>m4` - Instantly jump to slot 1-4.
- `<leader>mn` / `<leader>mp` - Jump to next / previous Harpoon bookmark.

#### Jump2D & Jump
- Press `<CR>` in Normal/Visual mode to display labels on every 2-character spot on-screen. Type the label characters to teleport there (`mini.jump2d`).
- Press `f{char}` to jump to a character. Pressing `f` again will advance to the next match on the same line (`mini.jump`).

#### Sessions (mini.sessions)
Sessions are automatically stored and mapped to your workspace directory:
- `<leader>qs` - Restore session for current working directory.
- `<leader>ql` - Choose and restore from all saved sessions.
- `<leader>qd` - Skip saving the session when closing Neovim this session.

---

### 6. Integrated AI Pair Programming

#### Claude Code (claudecode.nvim)
Embeds Claude Code directly in your editor. Relies on your active terminal authentication (`claude login` — no API keys required).
- `:ClaudeCode` - Toggle Claude Code sidebar.
- `<leader>cf` - Focus / unfocus sidebar.
- `<leader>cs` (Visual) - Send highlighted selection to Claude context.
- `<leader>cb` - Add current buffer content to Claude context.
- `<leader>cy` / `<leader>cn` - Accept / deny a proposed diff from Claude.

#### CodeCompanion & Windsurf
- `<leader>ac` - Toggle CodeCompanion chat panel (requires `ANTHROPIC_API_KEY` set in shell).
- `<leader>aa` - Open CodeCompanion action prompt picker.
- `<leader>ai` (Visual) - Inline edit selection using a prompt.
- **Windsurf Ghost Text**: AI completions render inline.
  - `<M-l>` - Accept suggestion.
  - `<M-w>` - Accept next word.
  - `<M-e>` - Dismiss suggestion.
  - `<M-n>` / `<M-p>` - Next / previous suggestion.

#### Antigravity CLI (agy)
Run the Antigravity TUI directly in Neovim as a side terminal pane:
- `:Agy` - Opens a vertical terminal split running `agy` constrained to 30% of your screen width.


---

### 7. Snippets & Completion Mechanics

Completions (`blink.cmp`) pop up automatically. Completion sources run in priority order: **LSP → Snippets → Path → Buffer**.

#### Completion Controls
- `<Tab>` - Confirms current selection (or expands snippet) when completion menu is open. If menu is closed and ghost text is visible, accepts Windsurf suggestion. Otherwise, inserts a tab.
- `<S-Tab>` - Navigates backward in completion menu / snippet parameters.
- `<CR>` - Confirms selection (inserts newline if menu is closed).
- `<C-Space>` - Manually trigger completion.
- `<C-e>` - Dismiss menu.

#### Snippets (mini.snippets)
Snippets load from global (`snippets/global.json`) or filetype-specific configurations:
- Custom format in json files:
  ```json
  {
    "Arrow function": {
      "prefix": "af",
      "body": ["const ${1:name} = (${2:params}) => {", "\t$0", "}"],
      "description": "Arrow function"
    }
  }
  ```

#### Completion Icon Legend
| Icon | Kind | Icon | Kind |
| --- | --- | --- | --- |
| `󰊕` | Function | `` | Class |
| `󰆧` | Method | `` | Interface |
| `󰀫` | Variable | `` | Snippet |
| `󰉿` | Text | `󰈙` | File |

---

### 8. macOS Spanish Keyboard Guide

On Spanish Mac keyboards, several characters (`[`, `]`, `\`, `@`, `{`, `}`) are not directly accessible and require the Option modifier.

When terminals capture the Option key as Meta (`Alt`) for shortcut bindings (e.g. Alt+hjkl), typing Option+`[` can send control sequences instead of literal characters, breaking bracketed jumps (`]b`, `]c`, etc.).

#### Step 1: Terminal Setup
Configure your terminal emulator so the **Left Option** key functions as Alt/Meta, and the **Right Option** key functions as `Normal` to type special characters:
- **iTerm2**: Preferences → Profiles → Keys → Set Left Option to `Esc+`, Right Option to `Normal`.
- **Kitty**: Add `macos_option_as_alt left` in `kitty.conf`.
- **Alacritty**: Add `option_as_alt = "OnlyLeft"` under `[window]` in `alacritty.toml`.

*Use the **Right Option** key inside Neovim to type bracket symbols.*

#### Step 2: Configuration Remaps
Remaps built into this configuration to ease usage on Spanish keyboards:
- `,` is the local leader key (replacing `\`).
- `<C-p>` triggers the smart file finder (replacing `<C-\>`).
- Windsurf next/prev shortcuts mapped to `<M-n>`/`<M-p>` (replacing `<M-]>`/`<M-[>`).
- **Bracket Navigation Replacements**:
  - `]c` / `[c` (Hunks) ➡️ `<leader>gn` / `<leader>gp`
  - `]d` / `[d` (Diagnostics) ➡️ `<leader>en` / `<leader>ep`

---

## ⌨️ Unified Key Bindings Reference Card (Cheat Sheet)

*Leader Key is* `<Space>`.

### Files, Buffers & Windows
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `<leader><Space>` / `<C-p>` | Smart file picker | `<leader>ff` | Find files |
| `<leader>fg` | Live grep (ripgrep) | `<leader>fw` | Grep word under cursor |
| `<leader>fb` | Open buffers | `<leader>fr` | Recent files |
| `<leader>fP` / `<leader>fD` | Find / Grep in path | `<leader>fv` / `fV` | Visited files (session / all) |
| `<leader>e` / `<leader>E` | Explorer (toggle / curr file) | `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` / `<leader>bD` | Delete buffer (safe / force) | `<C-hjkl>` | Navigate split windows |
| `<C-Up/Down/Left/Right>` | Resize split windows | `<leader>q` / `Q` | Quit buffer / Quit all |

### LSP & Diagnostics
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `gd` / `gD` | Go to definition / declaration | `gi` / `gy` | Go to implementation / type |
| `gr` | References | `K` / `gK` | Hover docs / Signature help |
| `<leader>rn` | Rename symbol | `<leader>ca` | Code action |
| `<leader>f` / `<leader>F` | Format (LSP / conform) | `]d` / `[d` (or `<leader>en`/`ep`) | Next / previous diagnostic |
| `<leader>ld` / `<leader>lD` | Line diagnostics / Loclist | `<leader>lh` | Toggle inlay hints |
| `<leader>xx` / `<leader>xb` | Trouble (workspace / buffer docs) | `<leader>xs` / `xq` | Trouble (symbols / quickfix) |

### Git Operations
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `]c` / `[c` (or `<leader>gn`/`gp`) | Next / previous hunk | `<leader>hs` / `hr` | Stage hunk / Reset hunk |
| `<leader>hS` / `hR` | Stage buffer / Reset buffer | `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview hunk inline | `<leader>hb` / `tb` | Full blame popup / toggle line blame |
| `<leader>hd` / `hD` | Diff vs HEAD / HEAD~ | `<leader>hm` / `hM` | Diff vs main / custom branch |
| `<leader>td` | Toggle deleted hunks | `<leader>gs` / `gb` | mini.git: show at cursor / range blame |
| `<leader>gd` | mini.git: show diff source | `ih` (Text Object) | Inner hunk selection |

### Editing Actions
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `cc` / `gc` / `gbc` | Comment line / block | `sa` / `sd` / `sr` | Surround add / delete / replace |
| `<Tab>` / `<S-Tab>` | Completion / Snippet controls | `<CR>` | Jump2D label teleport (normal/visual) |
| `<A-hjkl>` | Move line/selection (Visual) | `gS` | Split/join expression toggle |
| `<leader>sp` / `sP` | Swap parameter next / prev | `<leader>us` | Toggle spell check |
| `<leader>o` / `O` | Insert newline below / above | `p` (Visual) | Paste without yanking |

### Bookmarks (Harpoon2)
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `<leader>ma` | Add current file to Harpoon | `<leader>mm` | Open Harpoon quick menu |
| `<leader>m1-4` | Jump to Harpoon slot 1 to 4 | `<leader>mn` / `mp` | Harpoon next / previous |

### AI Integrations
| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `:ClaudeCode` / `cf` | Claude sidebar toggle / focus | `<leader>cs` / `cb` | Send selection / buffer to Claude |
| `<leader>cy` / `cn` | Accept / deny Claude diff | `<leader>ac` / `aa` | CodeCompanion chat / actions |
| `<leader>ai` (Visual) | CodeCompanion inline edit | `<M-l>` / `<M-w>` | Windsurf accept (all / word) |
| `<M-e>` | Windsurf dismiss suggestion | `<M-n>` / `<M-p>` | Windsurf next / previous |
| `:Agy` | Open agy CLI in 30% side terminal split | | |


### Language-Specific Mappings
| Key | Action | Language | Key | Action | Language |
| --- | --- | --- | --- | --- | --- |
| `<leader>tt` | Async type check | TypeScript | `<leader>tw` | Watch mode type checker | TypeScript |
| `<leader>np` | Toggle package version popup | npm packages | `<leader>nu` / `nd` / `ni` | Update / delete / install pkg | npm packages |
| `<leader>gr` | Go run | Go | `<leader>gt` | Go test | Go |
| `<leader>gie` | Insert if err block | Go | `<leader>gfs` | Fill struct | Go |
| `<leader>gI` | Implement interface | Go | `<leader>pv` | Switch Python venv | Python |
