# Neovim Config Manual

> Leader key is `<Space>`.  
> Notation: `<leader>` = Space, `<C-x>` = Ctrl+x, `<M-x>` = Alt+x, `<S-x>` = Shift+x.

---

## Table of Contents

1. [Navigate Definitions & References](#1-navigate-definitions--references)
2. [Search & Replace](#2-search--replace)
3. [Find Files by Name](#3-find-files-by-name)
4. [Find Files by Content](#4-find-files-by-content)
5. [Visual Selection](#5-visual-selection)
6. [Multi-file Workflow](#6-multi-file-workflow)
7. [Claude Code — Embedded Chat](#7-claude-code--embedded-chat)
8. [Snippets & Completions](#8-snippets--completions)
9. [Quick Reference Card](#9-quick-reference-card)
10. [Spanish Mac Keyboard](#10-spanish-mac-keyboard)

---

## 1. Navigate Definitions & References

All LSP navigation is active as soon as a language server attaches (automatic on file open).

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `gr` | List all references (quickfix) |
| `K` | Hover documentation |
| `gK` | Signature help (function arguments) |
| `<leader>rn` | Rename symbol across the project |
| `<leader>ca` | Code actions (extract, fix, import…) |
| `<C-o>` | Jump back in jump list |
| `<C-i>` | Jump forward in jump list |

### Find from Telescope

| Key | Action |
|-----|--------|
| `<leader>fs` | Document symbols (current file) |
| `<leader>fS` | Workspace symbols (all files) |
| `<leader>fi` | All implementations |
| `<leader>fR` | All references |
| `<leader>ft` | Type definitions |

### Navigate by treesitter text objects

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / prev function start |
| `]F` / `[F` | Next / prev function end |
| `]C` / `[C` | Next / prev class |
| `]a` / `[a` | Next / prev parameter |

**Tip:** All of these work in operator-pending mode — `d]f` deletes to the next function start, `y[f` yanks back to the previous one.

---

## 2. Search & Replace

### In the current buffer

| Key | Action |
|-----|--------|
| `/pattern` | Forward search |
| `?pattern` | Backward search |
| `n` / `N` | Next / prev match |
| `*` / `#` | Search exact word under cursor fwd / bwd |
| `g*` / `g#` | Search partial word under cursor fwd / bwd |
| `<leader>f/` | Fuzzy search inside current buffer (Telescope) |
| `<Esc>` | Clear search highlights |

**nvim-hlslens** shows a `[x/N]` count overlay as virtual text next to each match as you navigate with `n`/`N`/`*`/`#`. `g*` and `g#` (partial-word search) are also enhanced.

### In-buffer rename / substitute

```
:%s/old/new/gc          " interactive replace in file
:s/old/new/g            " replace in selection (enter Visual first)
```

`c` flag = confirm each match. `I` flag = case-sensitive.

### Project-wide search & replace — grug-far

| Key | Action |
|-----|--------|
| `<leader>sr` | Open grug-far (empty query) |
| `<leader>sr` (Visual) | Open grug-far pre-filled with selection |
| `<leader>sw` | Open grug-far pre-filled with word under cursor (normal) |

Inside the grug-far panel:
- Edit the **Search** and **Replace** fields, then press `<CR>` on the replace button (or the displayed action key) to apply.
- Flags field accepts any ripgrep flag (`--type ts`, `-g '!dist'`, etc.).
- Results are live-previewed as you type.

### LSP rename (single symbol)

`<leader>rn` — renames every occurrence of the symbol under the cursor across all open project files, respecting language semantics.

---

## 3. Find Files by Name

| Key | Action |
|-----|--------|
| `<leader><Space>` / `<C-p>` | **Smart file picker** — git-tracked files if in a repo, all files otherwise |
| `<leader>ff` | All files (including hidden, respects `.gitignore`) |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recently opened files |
| `<leader>fv` | Visited files this session (frecency, mini.visits) |
| `<leader>fV` | All visited files ever (frecency) |
| `<leader>fP` | Files in a specific directory (prompts for path) |

### Inside the Telescope picker

| Key | Action |
|-----|--------|
| Type | Fuzzy filter |
| `<C-j>` / `<C-k>` | Move selection down / up |
| `<CR>` | Open in current window |
| `<C-v>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `<C-q>` | Send all matches to quickfix list |
| `<Esc>` | Close picker |

---

## 4. Find Files by Content

### Live grep (ripgrep)

| Key | Action |
|-----|--------|
| `<leader>fg` | Live grep in CWD (updates as you type) |
| `<leader>fw` | Grep word under cursor in CWD |
| `<leader>fD` | Live grep in a specific directory (prompts for path) |
| `<leader>fp` | Re-open last Telescope picker with previous query |

Live grep searches all files including hidden ones (`--hidden` flag is on by default).

### Quickfix workflow

1. Run `<leader>fg`, find matches, press `<C-q>` — all results land in the quickfix list.
2. Navigate with `[q` / `]q` (prev/next entry) or `:copen` to browse the panel.
3. `<leader>xq` opens the Trouble quickfix panel for a richer view.

### Diagnostics search

| Key | Action |
|-----|--------|
| `<leader>fd` | Telescope diagnostics (all files) |
| `<leader>xx` | Trouble workspace diagnostics panel |
| `<leader>xb` | Trouble buffer diagnostics panel |
| `<leader>xs` | Trouble document symbols panel |
| `]d` / `[d` | Jump to next / prev diagnostic inline |
| `<leader>en` / `<leader>ep` | Next / prev diagnostic (Spanish Mac alternative to `]d`/`[d`) |
| `<leader>ld` | Float current line diagnostic |
| `<leader>lh` | Toggle inlay hints (when LSP supports it) |

---

## 5. Visual Selection

### Standard visual modes

| Key | Mode |
|-----|------|
| `v` | Character-wise visual |
| `V` | Line-wise visual |
| `<C-v>` | Block visual (column select) |
| `gv` | Reselect last visual area |
| `o` | (in visual) Move cursor to opposite end |

### Treesitter text object selections

Enter Visual or Operator-pending mode, then:

| Key | Selects |
|-----|---------|
| `af` / `if` | Outer / inner function |
| `ac` / `ic` | Outer / inner class |
| `aa` / `ia` | Outer / inner argument / parameter |
| `ab` / `ib` | Outer / inner block `{}` |
| `al` / `il` | Outer / inner loop |
| `ai` / `ii` | Outer / inner conditional |

**Examples:**
- `vaf` — visually select the entire function including its signature
- `dif` — delete function body only
- `yac` — yank the whole class
- `cia` — change a function argument

### mini.ai extended text objects

In addition to the treesitter ones above, mini.ai adds:

| Key | Selects |
|-----|---------|
| `a"` / `i"` | Around / inside double quotes |
| `a'` / `i'` | Around / inside single quotes |
| `a(` / `i(` | Around / inside parentheses |
| `a{` / `i{` | Around / inside braces |
| `a[` / `i[` | Around / inside brackets |
| `at` / `it` | Around / inside HTML tag |

### Surround operations (mini.surround)

These work on visual selections or with motion:

| Key | Action | Example |
|-----|--------|---------|
| `sa{motion}{char}` | Add surrounding | `saiw"` → surround word with `"` |
| `sd{char}` | Delete surrounding | `sd"` → remove surrounding `"` |
| `sr{old}{new}` | Replace surrounding | `sr'"` → replace `'` with `"` |
| `sf{char}` | Find surrounding (forward) | |
| `sh{char}` | Highlight surrounding | |

In Visual mode: `sa"` to wrap selection in double quotes.

### Move selected lines

| Key | Action |
|-----|--------|
| `<A-j>` / `<A-k>` | Move selection down / up (Visual mode) |
| `<A-h>` / `<A-l>` | Move selection left / right (Visual mode) |
| `<` / `>` | Indent left / right (stays in Visual) |

### Commenting (mini.comment)

| Key | Action |
|-----|--------|
| `gc{motion}` | Comment / uncomment a motion |
| `gcc` | Comment / uncomment current line |
| `gc` (Visual) | Comment / uncomment selection |
| `gbc` | Comment current line as block comment |

Examples: `gcap` comments a paragraph, `gc3j` comments 3 lines down.

### Send selection to Claude

`<leader>cs` (Visual) — sends the selected code to the Claude Code sidebar as context.

---

## 6. Multi-file Workflow

### File explorer (mini.files)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Open explorer at the current file's directory |

Inside the explorer: navigate with `hjkl`, `<CR>` to open, `a` to create, `r` to rename, `d` to delete. Changes are **not applied until you save** with `:w` inside the explorer buffer.

### Buffer navigation

| Key | Action |
|-----|--------|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>fb` | Fuzzy pick from open buffers |
| `<leader>bd` | Delete buffer (preserves window layout) |
| `<leader>bD` | Force-delete buffer |

### Window splits

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-Up/Down>` | Resize window height |
| `<C-Left/Right>` | Resize window width |
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-w>q` | Close window |

### Harpoon — fast file bookmarks

Harpoon gives you up to 4 instant-access file slots per project.

| Key | Action |
|-----|--------|
| `<leader>ma` | Add current file to harpoon list |
| `<leader>mm` | Open harpoon menu (edit/reorder list) |
| `<leader>m1` – `<leader>m4` | Jump to slot 1–4 |
| `<leader>mn` / `<leader>mp` | Next / prev in harpoon list |

**Workflow:** Open the 4 files you're actively working on, add them all with `<leader>ma`, then use `<leader>m1`–`4` to teleport between them instantly — no fuzzy searching needed.

### Jump to any visible location (mini.jump2d)

`<CR>` — labels every 2-character spot on screen. Type the label to teleport there. Dims the rest of the screen for focus.

### Enhanced f/F/t/T (mini.jump)

After pressing `f{char}` to jump to a character, press `f` again to advance to the next occurrence on the same line (instead of repeating the full `f{char}`).

### Bracket navigation (mini.bracketed)

All pairs use `]` for forward and `[` for backward. On Spanish Mac keyboards these require
the right Option key after configuring the terminal (see section 10).

| Key | Action |
|-----|--------|
| `]b` / `[b` | Next / prev buffer |
| `]c` / `[c` | Next / prev git hunk (gitsigns) |
| `]d` / `[d` | Next / prev diagnostic |
| `]i` / `[i` | Next / prev indent level change |
| `]j` / `[j` | Next / prev jumplist entry |
| `]l` / `[l` | Next / prev location list entry |
| `]o` / `[o` | Next / prev oldfile (`:oldfiles`) |
| `]q` / `[q` | Next / prev quickfix entry |
| `]t` / `[t` | Next / prev treesitter node |
| `]u` / `[u` | Next / prev undo state |
| `]w` / `[w` | Next / prev window |
| `]x` / `[x` | Next / prev comment block |
| `]y` / `[y` | Next / prev yank |

### Git workflow

**Hunk navigation**

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / prev git hunk |
| `<leader>gn` / `<leader>gp` | Next / prev hunk (Spanish Mac alternative) |

**Hunk operations (gitsigns)**

| Key | Action |
|-----|--------|
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hu` | Undo last stage |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk diff inline |
| `<leader>hb` | Full blame for current line |
| `<leader>hd` | Diff current file vs HEAD |
| `<leader>hD` | Diff current file vs HEAD~ |
| `<leader>hm` | Diff current file vs main |
| `<leader>hM` | Diff current file vs any branch (prompts) |
| `<leader>tb` | Toggle inline blame on current line |
| `<leader>td` | Toggle deleted hunk display |
| `ih` | Text object: select inner hunk (use with `d`, `y`, `c`) |

**Git log / diff (mini.git)**

| Key | Action |
|-----|--------|
| `<leader>gs` | Show git object at cursor (log, blame, diff) |
| `<leader>gb` | Blame history for current line range |
| `<leader>gd` | Show diff source for the change under cursor |

**Telescope git pickers**

| Key | Action |
|-----|--------|
| `<leader>fgc` | Browse git commits |
| `<leader>fgb` | Browse branches |
| `<leader>fgs` | Git status |

### Split / join argument lists (mini.splitjoin)

`gS` on any line with a function call, array, or object literal:
- Single line → expands arguments to multiple lines
- Multi-line → joins back to a single line

### Swap parameters (treesitter)

| Key | Action |
|-----|--------|
| `<leader>sp` | Swap current parameter with the next one |
| `<leader>sP` | Swap current parameter with the previous one |

### Save

| Key | Action |
|-----|--------|
| `<C-s>` | Save (normal, insert, visual) |
| `<leader>w` | Save (normal) |

### Formatting

| Key | Action |
|-----|--------|
| `<leader>F` | Format with conform (prettier / black / gofumpt) |
| `<leader>f` | Format with LSP (native) |

Go files are auto-formatted on save via gopls.  
Trailing whitespace is automatically trimmed on every save.

### Sessions

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session for current directory |
| `<leader>ql` | Pick and restore any saved session |
| `<leader>qd` | Skip saving session when exiting this time |

Sessions are auto-saved on every Neovim exit, keyed to the current working directory.

---

## 7. Claude Code — Embedded Chat

This config embeds Claude Code via [claudecode.nvim](https://github.com/coder/claudecode.nvim), which connects to the same Claude CLI you use in the terminal. No API key needed — it uses your `claude login` session.

### Opening and managing the sidebar

| Key | Action |
|-----|--------|
| `<leader>cc` | Toggle Claude Code sidebar |
| `<leader>cf` | Focus / unfocus sidebar |

The sidebar opens on the right at 35% width. You can type multi-line prompts directly in it, just like the terminal Claude.

### Sending context to Claude

| Key | Action |
|-----|--------|
| `<leader>cb` | Add current buffer as context |
| `<leader>cs` (Visual) | Send selected code as context |

**Workflow for code questions:**
1. Select a function or block with `vaf` (visual around function).
2. Press `<leader>cs` to send it.
3. The sidebar receives it — type your question.

**Workflow for multi-file context:**
1. Open each file you want to discuss.
2. Press `<leader>cb` in each buffer.
3. Claude sees all of them; ask your question.

### Accepting / rejecting Claude's edits

When Claude proposes a diff to your file:

| Key | Action |
|-----|--------|
| `<leader>cy` | Accept diff |
| `<leader>cn` | Deny diff |

### Additional AI tools

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle CodeCompanion chat (requires `ANTHROPIC_API_KEY`) |
| `<leader>aa` | CodeCompanion action picker (prompt library) |
| `<leader>ai` (Visual) | CodeCompanion inline edit — apply a prompt to selection |
| `<Tab>` | Accept Windsurf ghost-text suggestion (when blink.cmp menu is closed) |
| `<M-w>` | Accept one word of ghost-text |
| `<M-e>` | Dismiss ghost-text |
| `<M-n>` / `<M-p>` | Next / prev ghost-text suggestion |

Windsurf provides inline ghost-text completions independent of the LSP completion menu. First-time setup: run `:Codeium Auth`.  
`<Tab>` is shared between blink.cmp and Windsurf: if the blink.cmp menu is open it confirms that selection; if only ghost text is visible it accepts the Windsurf suggestion; otherwise it inserts a literal tab.

---

## 8. Snippets & Completions

### Completion menu (blink.cmp)

The completion menu appears automatically as you type. Sources in priority order: LSP → Snippets → Path → Buffer.

| Key | Action |
|-----|--------|
| `<Tab>` | If blink menu open: confirm selection / expand snippet. If only Windsurf ghost text visible: accept it. Otherwise: insert tab. |
| `<S-Tab>` | Select previous item / navigate snippet backward |
| `<CR>` | Confirm blink.cmp selection (or newline if menu closed) |
| `<C-Space>` | Manually trigger completion |
| `<C-e>` | Cancel and close menu |
| `<C-b>` / `<C-f>` | Scroll documentation popup up / down |

A ghost-text preview of the top LSP/buffer suggestion appears inline from blink.cmp itself. Windsurf ghost text (AI) also renders inline and is accepted with the same `<Tab>` key when the blink menu is not open.

The signature help popup appears automatically when you open a function's parentheses, showing parameter names and types.

### Snippets (mini.snippets)

Snippets are loaded from:
- Per-language files (e.g., `snippets/typescript.json`)
- Global snippets at `~/.config/nvim/snippets/global.json`

Snippets appear in the completion menu with a `` kind icon. Select and confirm with `<CR>`, then:
- `<Tab>` / `<S-Tab>` to jump between tab stops
- Type to fill in the placeholder

**Adding a new snippet:** Edit the appropriate `snippets/<lang>.json` (or `global.json`). Format:

```json
{
  "Arrow function": {
    "prefix": "af",
    "body": ["const ${1:name} = (${2:params}) => {", "\t$0", "}"],
    "description": "Arrow function"
  }
}
```

### LSP-powered completions

LSP completions include:
- Function signatures with parameter info
- Auto-imports (TypeScript, Go)
- Enum members, class properties, module exports

When a completion with an auto-import is confirmed, the import statement is added to the top of the file automatically.

### Kind icons legend

| Icon | Kind |
|------|------|
| `󰊕` | Function |
| `󰆧` | Method |
| `` | Class |
| `` | Interface |
| `󰀫` | Variable |
| `` | Snippet |
| `󰉿` | Text |
| `󰈙` | File |

---

## 9. Quick Reference Card

### Most-used daily keys

```
Navigation
  <leader><Space>   smart file picker (also <C-p>)
  <leader>ff        find files
  <leader>fg        live grep
  <leader>fb        open buffers
  <leader>fr        recent files
  <leader>fv        visited files (session)
  <leader>fs        document symbols
  gd / gr / gi / gy go to definition / references / impl / type
  K                 hover docs
  <C-o> / <C-i>    jump back / forward
  <CR>              jump2d (label-based teleport)

Harpoon
  <leader>ma        add to harpoon
  <leader>mm        harpoon menu
  <leader>m1-4      jump to slot

Git
  ]c / [c           next/prev hunk  (or <leader>gn / <leader>gp)
  <leader>hs        stage hunk
  <leader>hp        preview hunk
  <leader>hb        blame line
  <leader>gd        diff source at cursor

Diagnostics
  ]d / [d           next/prev diagnostic  (or <leader>en / <leader>ep)
  <leader>xx        workspace diagnostics panel
  <leader>ld        float current line diagnostic

Search & Replace
  <leader>fg        live grep (search)
  <leader>sr        grug-far (replace)
  <leader>sw        grug-far word under cursor
  <leader>rn        LSP rename symbol

Editing
  gS                split/join arguments
  gc / gcc          comment selection / line
  sa / sd / sr      surround add/delete/replace
  <leader>sp        swap next parameter
  <leader>F         format file (conform)

Claude Code
  <leader>cc        toggle sidebar
  <leader>cs        send selection (Visual)
  <leader>cb        add buffer to context
  <leader>cy        accept diff
  <leader>cn        deny diff

Completion
  <Tab>             blink menu open → confirm/snippet; ghost text only → accept Windsurf; else → tab
  <CR>              confirm blink selection (or newline)
  <M-n> / <M-p>    next / prev Windsurf suggestion
  <M-w>             accept one word of Windsurf ghost text
  <M-e>             dismiss Windsurf ghost text
```

---

> Run `:checkhealth` to verify all language servers and tools are installed.  
> Press `<Space>` and wait 400 ms to see all available keymaps via mini.clue.

---

## 10. Spanish Mac Keyboard

On a Spanish (Spain or Latin American) Mac keyboard, several keys used in this config
are not directly accessible:

| Character | Status |
|-----------|--------|
| `[` `]` | No dedicated key — require Option modifier |
| `` ` `` backtick | Dead key — pressing alone produces nothing |
| `\` backslash | Requires Option modifier |
| `@` | Requires Option modifier (affects `@q` macro replay) |
| `{` `}` | Require Option modifier |

The critical terminal conflict: when the terminal sets **Option = Meta** (needed for
`<M-x>` bindings like Windsurf ghost-text), pressing Option+`[` sends `ESC [` (a raw
escape sequence) instead of the literal `[` character — breaking every `]x`/`[x`
navigation binding.

### Step 1 — Configure your terminal

Set up your terminal so **left** Option = Meta (for Vim bindings) and **right** Option
still types special characters (`[`, `]`, `@`, `{`, etc.).

**iTerm2**
1. Preferences → Profiles → Keys
2. Left Option Key: **`Esc+`**
3. Right Option Key: **`Normal`**

After this: use the **right** Option key to type `[` and `]` in Neovim.
All `<M-x>` bindings (Windsurf, mini.move, etc.) use the left Option key.

**Kitty**
```
# ~/.config/kitty/kitty.conf
macos_option_as_alt left
```

**Alacritty**
```toml
# alacritty.toml
[window]
option_as_alt = "OnlyLeft"
```

### Step 2 — Changes already applied to this config

The following remaps have been applied so the most critical keymaps work without any
terminal configuration:

| Old key | New key | Reason |
|---------|---------|--------|
| `maplocalleader = \` | `,` | `\` requires Option |
| `option_toggle_prefix = \` | `,` | same |
| `<C-\>` buffer picker | removed | replaced by `<C-p>` |
| `<M-]>` Windsurf next suggestion | `<M-n>` | `]` requires Option |
| `<M-[>` Windsurf prev suggestion | `<M-p>` | `[` requires Option |

New leader alternatives added alongside the bracket navigation:

| Bracket key | Leader alternative | Action |
|-------------|-------------------|--------|
| `]c` | `<leader>gn` | Git: next hunk |
| `[c` | `<leader>gp` | Git: prev hunk |
| `]d` | `<leader>en` | Next diagnostic |
| `[d` | `<leader>ep` | Prev diagnostic |

Smart file picker added:

| Key | Action |
|-----|--------|
| `<C-p>` | Smart file picker (git files or all files) |

### Step 3 — What still needs the terminal fix

Once you configure your terminal (Step 1), all `]x`/`[x` navigation works using the
**right** Option key to type `[` and `]`:

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / prev function |
| `]F` / `[F` | Next / prev function end |
| `]C` / `[C` | Next / prev class |
| `]a` / `[a` | Next / prev parameter |
| `]c` / `[c` | Next / prev git hunk |
| `]d` / `[d` | Next / prev diagnostic |
| `]b` / `[b` | Next / prev buffer (mini.bracketed) |
| and all other `]x`/`[x` pairs | ... |

Until then, use the `<leader>gn`/`<leader>gp` and `<leader>en`/`<leader>ep` alternatives,
and the Telescope pickers as a fallback:

| Instead of | Use |
|------------|-----|
| `]f` / `[f` | `<leader>fs` (document symbols) then navigate |
| `]d` / `[d` | `<leader>en` / `<leader>ep` or `<leader>fd` |
| `]c` / `[c` | `<leader>gn` / `<leader>gp` |
| `]q` / `[q` | `<leader>xq` (Trouble quickfix panel) |

### Macro replay (`@q`)

`@` requires Option. Alternatives:
- `:normal @q<CR>` — runs macro `q` from the command line
- Add a one-off mapping: `map("n", "<leader>rq", "@q", { desc = "Run macro q" })`
- After terminal setup, right Option+`2` types `@` and macro replay works normally
