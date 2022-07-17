-- TODO: Find more suitable colors 
-- vim.cmd[[ hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
-- vim.cmd[[ hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
-- vim.cmd[[ hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]

require('hop').setup({
  case_insensitive = true,
  quit_key='<Esc>',
})

vim.keymap.set('n', 't', function()
return require('hop').hint_patterns()
end,
{ silent = true, noremap = true, desc = "nvim-hop patterns" })

vim.keymap.set('n', 'T', function()
return require('hop').hint_words()
end,
{ silent = true, noremap = true, desc = "nvim-hop words" })

