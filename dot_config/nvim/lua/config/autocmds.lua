-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable Spelling Check
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local disable_autoformat = {
  "markdown",
  "text",
  "sh",
  "c",
}

local disable_diagnostics = {
  "markdown",
}

-- Disable autoformat for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = disable_autoformat,
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Disable diagnostics for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = disable_diagnostics,
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Indent lines with '>' and '<'
-- A buffer-local keymap is required so nowait works
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.keymap.set("n", ">", "<<", { noremap = true, nowait = true, buffer = true, desc = "Indent line" })
    vim.keymap.set("n", "<", ">>", { noremap = true, nowait = true, buffer = true, desc = "Indent line" })
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})
