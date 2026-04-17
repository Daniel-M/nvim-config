-- lua/plugins/telescope.lua
local telescope = require("telescope")
local actions   = require("telescope.actions")
local builtin   = require("telescope.builtin")

telescope.setup({
  defaults = {
    prompt_prefix   = "  ",
    selection_caret = " ",
    entry_prefix    = "  ",
    sorting_strategy = "ascending",
    layout_strategy  = "horizontal",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      vertical   = { mirror = false },
      width      = 0.87,
      height     = 0.80,
      preview_cutoff = 120,
    },
    path_display    = { "truncate" },
    border          = true,
    borderchars     = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons  = true,
    winblend        = 0,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<Esc>"] = actions.close,
      },
      n = {
        ["q"]     = actions.close,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    find_files          = { hidden = true },
    live_grep           = { additional_args = { "--hidden" } },
    buffers             = { sort_lastused = true, ignore_current_buffer = true },
    lsp_references      = { show_line = false },
    lsp_document_symbols = { symbol_width = 0.8 },
  },
  extensions = {
    fzf = {
      fuzzy                   = true,
      override_generic_sorter = true,
      override_file_sorter    = true,
      case_mode               = "smart_case",
    },
  },
})

-- Load fzf native sorter (requires compiled library — run `make` in its pack dir).
-- Fails gracefully if not yet compiled so startup isn't blocked.
local ok, err = pcall(telescope.load_extension, "fzf")
if not ok then
  vim.notify("telescope-fzf-native not compiled: " .. err, vim.log.levels.WARN)
end

-- Keymaps
local map = vim.keymap.set

-- Files & search
map("n", "<leader>ff", builtin.find_files,                          { desc = "Find: files" })
map("n", "<leader>fg", builtin.live_grep,                           { desc = "Find: live grep" })
map("n", "<leader>fw", builtin.grep_string,                         { desc = "Find: word under cursor" })
map("n", "<leader>fb", builtin.buffers,                             { desc = "Find: buffers" })
map("n", "<leader>fr", builtin.oldfiles,                            { desc = "Find: recent files" })
map("n", "<leader>f/", builtin.current_buffer_fuzzy_find,           { desc = "Find: in current buffer" })
map("n", "<leader>fh", builtin.help_tags,                           { desc = "Find: help tags" })
map("n", "<leader>fc", builtin.commands,                            { desc = "Find: commands" })
map("n", "<leader>fk", builtin.keymaps,                             { desc = "Find: keymaps" })

-- LSP
map("n", "<leader>fs", builtin.lsp_document_symbols,                { desc = "Find: document symbols" })
map("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols,       { desc = "Find: workspace symbols" })
map("n", "<leader>fd", builtin.diagnostics,                         { desc = "Find: diagnostics" })
map("n", "<leader>fi", builtin.lsp_implementations,                 { desc = "Find: implementations" })
map("n", "<leader>fR", builtin.lsp_references,                      { desc = "Find: references" })
map("n", "<leader>ft", builtin.lsp_type_definitions,                { desc = "Find: type definitions" })

-- Git
map("n", "<leader>fgc", builtin.git_commits,                        { desc = "Find: git commits" })
map("n", "<leader>fgb", builtin.git_branches,                       { desc = "Find: git branches" })
map("n", "<leader>fgs", builtin.git_status,                         { desc = "Find: git status" })

-- Re-open last picker
map("n", "<leader>fp", builtin.resume,                              { desc = "Find: resume last" })

-- Smart git_files / find_files (auto-detects if inside a git repo)
_G.telescope_files_or_git_files = function()
  local utils = require("telescope.utils")
  local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
  if ret == 0 then
    builtin.git_files({ show_untracked = true })
  else
    builtin.find_files()
  end
end
map("n", "<leader><space>", telescope_files_or_git_files, { desc = "Find: smart files (git/all)" })
map("n", "<C-p>",          telescope_files_or_git_files, { desc = "Find: smart files (git/all)" })

-- Find files / grep in a specific directory (prompts for path)
_G.telescope_find_files_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  builtin.find_files({ search_dirs = { _path } })
end
_G.telescope_live_grep_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  builtin.live_grep({ search_dirs = { _path } })
end
map("n", "<leader>fP", telescope_find_files_in_path, { desc = "Find: files in dir…" })
map("n", "<leader>fD", telescope_live_grep_in_path,  { desc = "Find: grep in dir…" })

