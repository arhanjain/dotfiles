local utils = require("utils")
local fn = vim.fn

vim.g.package_home = fn.stdpath("data") .. "/site/pack/packer/"
local packer_install_dir = vim.g.package_home .. "/opt/packer.nvim"

local packer_repo = "https://github.com/wbthomason/packer.nvim"
local install_cmd = string.format("10split |term git clone --depth=1 %s %s", packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if fn.glob(packer_install_dir) == "" then
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
  vim.cmd(install_cmd)
  os.execute("sleep 5")
end

-- Load packer.nvim
vim.cmd("packadd packer.nvim")
local util = require('packer.util')

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
      end,
    }
    
    -- Themes
    use { 'sainnhe/everforest'}
    use { 'projekt0n/github-nvim-theme', opt = true }
    use {'EdenEast/nightfox.nvim'}
    end,
    config = {
    max_jobs = 16,
    compile_path = util.join_paths(fn.stdpath('data'), 'site', 'lua', 'packer_compiled.lua'),
  },
})

local status, _ = pcall(require, 'packer_compiled')

if not status then
	vim.notify("Error requiring packer_compiled.lua: run PackerSync to fix!")
end

