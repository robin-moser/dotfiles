-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local options = {
  -- Display line numbers
  number = true,
  -- Keep signcolumn on by default
  signcolumn = "yes",
  -- Don't set relative numbered lines
  relativenumber = false,
  -- Don't sync clipboard between OS and Neovim
  clipboard = "",
  -- Don't wrap lines by default
  wrap = true,
  -- Companion to wrap, don't split words
  linebreak = true,
  -- Enable mouse mode
  mouse = "a",
  -- Minimal number of screen lines to keep above and below the cursor
  scrolloff = 6,
  -- Minimal number of screen columns either side of cursor if wrap is "false"
  sidescrolloff = 6,
  -- Confirm before closing unsaved buffers
  confirm = true,

  -- Copy indent from current line when starting new one
  autoindent = true,
  -- The number of spaces inserted for each indentation
  shiftwidth = 4,
  -- Insert n spaces for a tab
  tabstop = 4,
  -- Number of spaces that a tab counts for while performing editing operations
  softtabstop = 4,
  -- Convert tabs to spaces
  expandtab = true,
  -- Insert Indents automatically
  smartindent = true,

  -- Case-insensitive searching UNLESS \C or capital in search
  ignorecase = true,
  -- Smart case
  smartcase = true,
  -- Display search matches in split window
  inccommand = "split",

  -- Don't highlight the current line
  cursorline = false,
  -- Set number column width to 4
  numberwidth = 4,
  -- Always show tabs
  showtabline = 1,
  -- Enable break indent
  breakindent = true,
  -- Show whitespace characters
  list = true,
  -- Characters to use for displaying whitespace characters
  listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
  },

  -- Don't create a swapfile in the current directory
  swapfile = true,
  -- Don't create a backup file
  backup = false,
  -- Don't write backup file when writing to a file
  writebackup = false,
  -- Don't save undo history
  undofile = false,
  -- Enable project-local .nvimrc files
  exrc = true,

  -- Decrease update time
  updatetime = 250,
  -- Time to wait for a mapped sequence to complete
  timeoutlen = 300,
  -- Don't conceal any characters by default
  conceallevel = 0,
}

local custom_options = {
  -- Set the path to your Python 3 interpreter
  python3_host_prog = "/opt/homebrew/bin/python3",
  -- Disable animations in snacks.nvim
  snacks_animate = false,
  -- Enable autoformatting on save
  autoformat = true,
  -- Disable AI completion in cmp.nvim
  ai_cmp = false,
  -- Disable GitHub Copilot
  copilot_enabled = false,
}

-- Apply the options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Apply global options
for k, v in pairs(custom_options) do
  vim.g[k] = v
end
