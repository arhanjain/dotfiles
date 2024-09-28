set mouse=a
set number
set signcolumn=yes:1
set scrolloff=999

" Add theme if respective package is installed
" theme package, colorscheme
" let s:theme =  ["nightfox.nvim", "duskfox"]
let s:theme =  ["everforest-nvim", "everforest"]

let s:status = v:true
try
  execute printf("packadd! %s", s:theme[0])
catch /^Vim\%((\a\+)\)\=:E919/
  let s:status = v:false
endtry

if s:status
  execute printf("colorscheme %s", s:theme[1])
else
  call v:lua.vim.notify("Colorscheme package not found, please load/install it.", "info")
endif


" Auto-generate packer_compiled.lua file
augroup packer_auto_compile
  autocmd!
  autocmd BufWritePost */nvim/lua/plugins.lua source <afile> | PackerCompile
augroup END
