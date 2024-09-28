local wk = require("which-key")

vim.o.timeout = true
vim.o.timeoutlen = 300
wk.setup{}

local terminal = require("nvterm.terminal")

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
    f = {vim.lsp.buf.formatting_sync, "Format"},
    l = {function() require("lsp_lines").toggle() end, "Toggle diagnostic lines"},
    q = {function() vim.diagnostic.setqflist({open=true}) end , "Diagnostics"},
    c = {vim.lsp.buf.code_action, "Code actions"},
  },
  d = {
    name = "Debug",
    b = {function() require("dap").toggle_breakpoint() end, "Breakpoint"},
    B = {function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Conditional breakpoint"},
    c = {function() require("dap").continue() end, "Continue"},
    i = {function() require("dap").step_into() end, "Step into"},
    o = {function() require("dap").step_over() end, "Step over"},
  }
}

local opts = {
  prefix = '<leader>',
}

wk.register(mappings, opts)
-- wk.add(mapping, opts)
