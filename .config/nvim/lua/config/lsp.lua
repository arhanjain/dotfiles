local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local cust_attach = function(client, bufnr)
  -- Mappings.
  local opts = { silent = true, buffer = bufnr }
--  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  --vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
--  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
--  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
--  vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
--  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer=bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',  -- show source in diagnostic popup window
        prefix = ' '
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and
        #vim.diagnostic.get() > 0
      then
          vim.diagnostic.open_float(nil, opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end
  })

  -- Set some key bindings conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
  end


  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require "lspconfig"
local utils = require("utils")

local cwd_dir = function()
	return vim.fn.getcwd()
end

-- Language server setup
if utils.executable('pyright') then
	lspconfig['pyright'].setup({
		root_dir = cwd_dir,
		on_attach = cust_attach,
		capabilities = capabilities,
	})
else
	vim.notify("pyright not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('clangd') then
  lspconfig.clangd.setup({
    on_attach = cust_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 500,
    },
  })
else
  vim.notify("clangd not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('vscode-json-language-server') then
  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })
else
  vim.notify("jsonls not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('bash-language-server') then
  lspconfig.bashls.setup{}
else
  vim.notify("bashls not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('docker-langserver') then
  lspconfig.dockerls.setup{}
else
  vim.notify("dockerls not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('typescript-language-server') then
  lspconfig.tsserver.setup{}
else
  vim.notify("tsserver not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('vscode-css-language-server') then
  lspconfig.cssls.setup{
    capabilities = capabilities,
  }
else
  vim.notify("cssserver not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('cssmodules-language-server') then
  lspconfig.cssmodules_ls.setup{
    capabilities = capabilities,
    init_options = {
        camelCase = 'dashes',
    },
  }
else
  vim.notify("cssmodules_ls not found!", 'warn', {title = 'Nvim-config'})
end

-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { numhl = "LspDiagnosticsLineNrError" })
fn.sign_define("DiagnosticSignWarn", { numhl = "LspDiagnosticsLineNrWarning" })
fn.sign_define("DiagnosticSignInformation", { numhl = "LspDiagnosticsLineNrInfo" })
fn.sign_define("DiagnosticSignHint", { numhl = "LspDiagnosticsLineNrHint" })
vim.cmd("highlight LspDiagnosticsLineNrError guifg=#eb6f92 guibg=#412d44 gui=bold")
vim.cmd("highlight LspDiagnosticsLineNrWarning guifg=#f6c177 guibg=#433940 gui=bold")
vim.cmd("highlight LspDiagnosticsLineNrInfo guifg=#569fba guibg=#2b344a gui=bold")
vim.cmd("highlight LspDiagnosticsLineNrHint guifg=#a3be8c guibg=#363943 gui=bold")

-- global config for diagnostic
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
})

lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
