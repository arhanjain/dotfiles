local fn = vim.fn

function conditional_treesitter_config()
if io.open("config.treesitter", "r")~=nil then
    return
  else
    require("config.treesitter")
  end
end


-- Load packer.nvim
vim.cmd("packadd packer.nvim") local util = require('packer.util')

require("packer").startup({
  function()
    -- Speed up startup time
  --	use {'lewis6991/impatient.nvim', config = [[require('impatient')]]}

    -- Packer manages itself
    use {'wbthomason/packer.nvim', opt = true}

    -- LSP Kind: Pictograms for completion
    use {"onsails/lspkind-nvim", event = "VimEnter"}
    -- Autocompletion
    use {"hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]]}

    -- nvim-cmp completion sources
    use {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"}
    use {"hrsh7th/cmp-path", after = "nvim-cmp"}
    use {"hrsh7th/cmp-buffer", after = "nvim-cmp"}

    use({"SirVer/ultisnips", event = 'InsertEnter'})
    use {"quangnguyen30192/cmp-nvim-ultisnips", after = {'nvim-cmp', 'ultisnips'}}

    -- LSP Config
    use {"neovim/nvim-lspconfig",after = "cmp-nvim-lsp", config = [[require "config.lsp"]]}

    -- Treesitter (errors first launch if not installed)
    use {"nvim-treesitter/nvim-treesitter", event = "BufEnter", run = ":TSUpdate", config = [[require('config.treesitter')]] }

    -- Web devicons required by multiple plugins
    use {'kyazdani42/nvim-web-devicons'}

    -- Tree File Explorer
    use {
      'kyazdani42/nvim-tree.lua',
      tag = 'nightly',    
      requires = 'kyazdani42/nvim-web-devicons',
      config = [[require('config.nvim-tree')]],
    }

    -- Lua Line
    use { 
      'nvim-lualine/lualine.nvim',
      event = 'VimEnter',
      requires = 'kyazdani42/nvim-web-devicons',
      config = [[require('config.lualine')]]}

    -- Buffer Line
    use {'akinsho/bufferline.nvim',
      tag = "v2.*",
      requires = 'kyazdani42/nvim-web-devicons',
      config = [[require('config.bufferline')]],
    }

    -- Fast buffer jumping with Hop
    use {
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function() require('config.hop') end, 2000)
      end,
    }
    
    -- Telescope fuzzyfinder with symbols
    use {
      'nvim-telescope/telescope.nvim',
      requires = {'nvim-lua/plenary.nvim'},
      config = [[require('config.telescope')]],
    }
    use {'nvim-telescope/telescope-symbols.nvim', after = 'telescope.nvim'}

    -- Shortcuts and keybinding documentation with Which Key
    use { "folke/which-key.nvim", config = [[require('config.which-key')]] }

    -- Git integration
    use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]], event = 'BufEnter' }

    -- Themes
    use { 'sainnhe/everforest', opt = true}
    use { 'projekt0n/github-nvim-theme', opt = true }
    use {'EdenEast/nightfox.nvim', opt = true}

    -- Discord Rich Presence
    use 'andweeb/presence.nvim'

    end,
    config = {
    max_jobs = 16,
    compile_path = util.join_paths(fn.stdpath('data'), 'site', 'lua', 'packer_compiled.lua'),
  },
})

--require("nvim-tree").setup{}
local status, _ = pcall(require, 'packer_compiled')
 
if not status then
   os.execute("sleep 1")
   --vim.notify("Error requiring packer_compiled.lua: run PackerSync to fix!", "info")
end

