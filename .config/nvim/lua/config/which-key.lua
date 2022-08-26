local wk = require("which-key")
wk.setup{}

local mappings = {
  q = {":q<cr>", "Quit"},
  w = {":w<cr>", "Save"},
  W = {":wq<cr>", "Save & Quit"},
  x = {":bd<cr>", "Close"},
  e = {":NvimTreeToggle<cr>", "Toggle Tree"},
  [","] = {":BufferLineCyclePrev<cr>", "Previous buffer"},
  ["."] = {":BufferLineCycleNext<cr>", "Next buffer"},
  g = {
    name = "Go to",
    b = {":BufferLinePick<cr>", "Go to buffer"},
    d = {vim.lsp.buf.definition, "Go to definition"},
    r = {vim.lsp.buf.references, "Go to reference"},
    n = {vim.diagnostic.goto_next, "Go to next"},
    p = {vim.diagnostic.goto_prev, "Go to previous"},
  },
  T = {
    name = "Telescope",
    t = {":Telescope<cr>", "Launch Telescope"},
    f = {":Telescope find_files<cr>", "Find files"},
    g = {":Telescope live_grep<cr>", "Live grep"},
  },
  l = {
    name = "LSP",
    r = {vim.lsp.buf.rename, "Rename"},
    l = {function() require("lsp_lines").toggle() end, "Toggle diagnostic lines"},
    q = {function() vim.diagnostic.setqflist({open=true}) end , "Diagnostics"},
    c = {vim.lsp.buf.code_action, "Code actions"},
  }
}

local opts = {
  prefix = '<leader>',
}

wk.register(mappings, opts)
