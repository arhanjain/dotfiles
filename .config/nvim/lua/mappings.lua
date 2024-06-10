vim.g.mapleader = ' '
require("config.which-key")
local map = vim.api.nvim_set_keymap

-- KEYBINDS
-- Switching panes map('n', '<C-h>', '<C-w>h', { noremap = true, silent = false })
-- map('n', '<C-j>', '<C-w>j', { noremap = true, silent = false })
-- map('n', '<C-k>', '<C-w>k', { noremap = true, silent = false })
-- map('n', '<C-l>', '<C-w>l', { noremap = true, silent = false })

-- Escape Sequence
map('i', 'jk', '<ESC>', { noremap = true, silent = false })

-- Block Indenting
map('v', '<', '<gv', { noremap = true, silent = false })
map('v', '>', '>gv', { noremap = true, silent = false })

-- Telescope mappings
map('n', '<C-f>', ':Telescope find_files<cr>', { noremap = true, silent = false})
map('n', '<C-g>', ':Telescope live_grep<cr>', { noremap = true, silent = false})

-- Scrolling
-- Terminal buffer
-- local terminal = require("nvterm.terminal")
-- -- map('n', '<A-v>', function() terminal.toggle("vertical") end, {noremap=true, silent=false})
-- vim.keymap.set('n', '<M-v>', function() terminal.toggle("vertical") end, {noremap=true, silent=false})


vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
