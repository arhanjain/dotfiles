vim.g.mapleader = ' '
local map = vim.api.nvim_set_keymap

-- KEYBINDS

-- Switching panes
-- map('n', '<C-h>', '<C-w>h', { noremap = true, silent = false })
-- map('n', '<C-j>', '<C-w>j', { noremap = true, silent = false })
-- map('n', '<C-k>', '<C-w>k', { noremap = true, silent = false })
-- map('n', '<C-l>', '<C-w>l', { noremap = true, silent = false })

-- Escape Sequence
map('i', 'jk', '<ESC>', { noremap = true, silent = false })

-- Block Indenting
map('v', '<', '<gv', { noremap = true, silent = false })
map('v', '>', '>gv', { noremap = true, silent = false })


vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
