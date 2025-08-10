-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function opts(desc)
  return vim.tbl_extend("force", { noremap = true, silent = true }, { desc = desc })
end

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Open the dashboard
vim.keymap.set("n", "<leader>od", function()
  Snacks.dashboard.open()
end, opts("Open Dashboard"))

-- save file with explicit auto-formatting
vim.keymap.set("n", "<C-s>", function()
  LazyVim.format({ force = true })
  vim.cmd("noautocmd w")
end, opts("Format and save"))

-- save file without auto-formatting
vim.keymap.set("n", "<C-w>", function()
  vim.cmd("noautocmd w")
end, opts("Save without formatting"))

-- save file and close buffer with alt+q
vim.keymap.set("n", "<A-q>", function()
  vim.cmd("w")
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  vim.cmd("bd")
  if #buffers <= 1 then
    vim.cmd("quit")
  end
end, opts("Save and close buffer"))

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts(""))
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts(""))
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts(""))
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts(""))

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts(""))
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts(""))

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts(""))
vim.keymap.set("n", "N", "Nzzzv", opts(""))

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keep last yanked item in register when pasting in visual mode
vim.keymap.set("v", "p", '"_dP', opts(""))

-- Stay in indent mode
vim.keymap.set("v", "<", ">gv", opts(""))
vim.keymap.set("v", ">", "<gv", opts(""))

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts("Split windows vertically"))
vim.keymap.set("n", "<leader>h", "<C-w>s", opts("Split windows horizontally"))

-- Tabs
vim.keymap.set("n", "<leader><Tab>j", ":tabnext<CR>", opts("Next Tab"))
vim.keymap.set("n", "<leader><Tab>k", ":tabprevious<CR>", opts("Previous Tab"))

-- Previous diagnostic message
vim.keymap.set("n", "öd", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

-- Next diagnostic message
vim.keymap.set("n", "äd", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

-- Shift+y yank to system clipboard
vim.keymap.set({ "n", "v" }, "<S-y>", '"+y', opts("Yank to system clipboard"))

-- Leader+p paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', opts("Paste from system clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', opts("Paste from system clipboard before cursor"))

-- Block Commenting
vim.keymap.set("n", "<Leader>c<Space>", "gcc", { desc = "Toggle line comment", remap = true })
vim.keymap.set("v", "<Leader>c<Space>", "gc", { desc = "Toggle block comment", remap = true })

vim.keymap.del("", "gco")
vim.keymap.del("", "gcO")

-- add newline below with Enter
vim.keymap.set("n", "<CR>", function()
  vim.cmd("setlocal formatoptions-=o")
  vim.cmd("normal! o")
  vim.cmd("setlocal formatoptions+=o")
end, opts("Add newline below"))

-- add newline above with Enter
vim.keymap.set("n", "<S-CR>", function()
  vim.cmd("setlocal formatoptions-=o")
  vim.cmd("normal! O")
  vim.cmd("setlocal formatoptions+=o")
end, opts("Add newline above"))

-- Leader+u+H disable hipattern (colorization of colors)
vim.keymap.set("n", "<leader>uH", function()
  require("nvim-highlight-colors").toggle()
end, opts("Disable Hipatterns"))

-- Apply Quickfix on current line
vim.keymap.set("n", "<leader>qf", function()
  vim.lsp.buf.code_action({ apply = true })
end, opts("Apply Quickfix"))
