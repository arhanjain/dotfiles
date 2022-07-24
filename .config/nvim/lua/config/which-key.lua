local wk = require("which-key")

local mappings = {
  q = {":q<cr>", "Quit"},
  Q = {":q!<cr>", "Force Quit"},
  w = {":w<cr>", "Save"},
  W = {":wq<cr>", "Save & Quit"},
  x = {":bdelete<cr>", "Close"},
  e = {":NvimTreeToggle<cr>", "Toggle Tree"},
  t = {
    name = "Telescope",
    t = {":Telescope<cr>", "Launch Telescope"},
    f = {":Telescope find_files<cr>", "Find files"},
    g = {":Telescope live_grep<cr>", "Live grep"},
  },
  l = {
    name = "LSP",
    r = {vim.lsp.buf.rename, "Rename"},
    q = {function() vim.diagnostic.setqflist({open=true}) end , "Diagnostics"},
    c = {vim.lsp.buf.code_action, "Code actions"},
    g = {
      name = "Go to",
      d = {vim.lsp.buf.definition, "Go to definition"},
      r = {vim.lsp.buf.references, "Go to reference"},
      n = {vim.diagnostic.goto_next, "Go to next"},
      p = {vim.diagnostic.goto_prev, "Go to previous"},
    },
  }
}

local opts = {
  prefix = '<leader>',
}

wk.register(mappings, opts)
