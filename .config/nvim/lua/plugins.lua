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


    use({"SirVer/ultisnips", event = 'InsertEnter',})
    use {"quangnguyen30192/cmp-nvim-ultisnips", after = {'nvim-cmp', 'ultisnips'}}

    -- Github Copilot
    use {"zbirenbaum/copilot.lua", event = {"VimEnter"}, config = [[require('config.copilot')]]}
    use {"zbirenbaum/copilot-cmp", module = "copilot_cmp"}

    -- mason language package manager
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }

    -- Java LSP & More
    use { 'mfussenegger/nvim-jdtls' }

    -- LSP Config
    use {"neovim/nvim-lspconfig", after = {"cmp-nvim-lsp"}, config = [[require "config.lsp"]]}

    -- Diagnostic Lines
    use {"https://git.sr.ht/~whynothugo/lsp_lines.nvim", after = "nvim-lspconfig", config = [[require('lsp_lines').setup()]]}

    -- Debugging
    -- use { "rcarriga/nvim-dap-ui"}
    -- use { "mfussenegger/nvim-dap-python" }
    -- use { "mfussenegger/nvim-dap", config = [[require('config.dap')]] }

    -- Treesitter (errors first launch if not installed)
    use {"nvim-treesitter/nvim-treesitter", event = "BufEnter", run = ":TSUpdate", config = [[require('config.treesitter')]] }

    -- Web devicons required by multiple plugins
    use {'kyazdani42/nvim-web-devicons'}

    -- Tree File Explorer
    use {
      'kyazdani42/nvim-tree.lua',
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

    use { "numToStr/Comment.nvim", config = [[require('Comment').setup()]] }

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

    -- Kitty navigation
    -- use { 'knubie/vim-kitty-navigator', run = "cp ./*.py ~/.config/kitty/" }
    use { 'hermitmaster/nvim-kitty-navigator', run = 'cp kitty/* ~/.config/kitty/', config = [[require('nvim-kitty-navigator').setup{}]] }

    -- Themes
    -- Changing kitty background to match
    use { "shaun-mathew/Chameleon.nvim", config = [[require('chameleon').setup()]] }
    -- use { 'sainnhe/everforest', opt = true}
    use { 'projekt0n/github-nvim-theme', opt = true}
    use {'EdenEast/nightfox.nvim', opt = true}
    use {"neanias/everforest-nvim", config = [[require('everforest').setup()]] }
    -- Discord Rich Presence
    use 'andweeb/presence.nvim'
    

    -- Terminal Buffers
    use { "NvChad/nvterm", config = [[require('nvterm').setup()]] }

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

