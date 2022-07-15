lua require('init')

if has('termguicolors')
	set termguicolors
endif

set background=dark

colorscheme everforest

augroup packer_auto_compile
  autocmd!
  autocmd BufWritePost */nvim/lua/plugins.lua source <afile> | PackerCompile
augroup END


