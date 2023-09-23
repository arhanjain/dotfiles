local whichkey = {
  show = function()
    vim.fn.VSCodeNotify("whichkey.show")
  end
}

local comment = {
  selected = function()
    vim.fn.VSCodeNotifyRange("editor.action.commentLine", vim.fn.line("v"), vim.fn.line("."), 1)
  end
}

vim.g.mapleader = " "
vim.keymap.set({ 'n', 'v' }, "<leader>", whichkey.show)


-- Better Navigation
local navigation = {
  left = function()
    vim.fn.VSCodeNotify("workbench.action.navigateLeft")
  end,
  right = function()
    vim.fn.VSCodeNotify("workbench.action.navigateRight")
  end,
  up = function()
    vim.fn.VSCodeNotify("workbench.action.navigateUp")
  end,
  down = function()
    vim.fn.VSCodeNotify("workbench.action.navigateDown")
  end,
  nextTab = function()
    vim.fn.VSCodeNotify("workbench.action.nextEditor")
  end,
  prevTab = function()
    vim.fn.VSCodeNotify("workbench.action.previousEditor")
  end,
}
vim.keymap.set({ 'n', 'v', 'x' }, "<C-h>", navigation.left)
vim.keymap.set({ 'n', 'v', 'x' }, "<C-l>", navigation.right)
vim.keymap.set({ 'n', 'v' }, "<C-k>", navigation.up)
vim.keymap.set({ 'n', 'v' }, "<C-j>", navigation.down)
vim.keymap.set({ 'n', 'v' }, "<Tab>", navigation.nextTab)
vim.keymap.set({ 'n', 'v' }, "<S-Tab>", navigation.prevTab)


