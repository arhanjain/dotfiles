local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local new_install = false
if fn.empty(fn.glob(install_path)) > 0 then
  new_install = "true"
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end


--vim.cmd[[packadd packer.nvim]]

return require("packer").startup(function()
	-- Speed up startup time
--	use {'lewis6991/impatient.nvim', config = [[require('impatient')]]}

	-- Packer manages itself
	use {'wbthomason/packer.nvim'}

	-- LSP Kind: Pictograms for completion
	use {"onsails/lspkind-nvim", event = "VimEnter"}
	-- Autocompletion
	use {"hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]]}

	-- nvim-cmp completion sources
	use {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"}
	use {"hrsh7th/cmp-path", after = "nvim-cmp"}
	use {"hrsh7th/cmp-buffer", after = "nvim-cmp"}

	-- LSP Config
	use {"neovim/nvim-lspconfig",after = "cmp-nvim-lsp", config = [[require "config.lsp"]]}

  -- Treesitter
  use {"nvim-treesitter/nvim-treesitter", event = "BufEnter", run = ":TSUpdate", config = [[require("config.treesitter")]] }

	-- Lua Line
	use {'kyazdani42/nvim-web-devicons', event = 'VimEnter'}
	use { 'nvim-lualine/lualine.nvim', event = 'VimEnter', config = [[require('config.lualine')]]}

  -- Fast buffer jumping with Hop
  use {
    "phaazon/hop.nvim",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function() require('config.hop') end, 2000)
    end
  }
	
	-- Themes
	use { 'sainnhe/everforest'}
	use { 'projekt0n/github-nvim-theme', opt = true }
	use {'EdenEast/nightfox.nvim'}
	
  if new_install then
    require('packer').sync()
  end
end)

		
