local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local custom_attach = function(client, bufnr)
  -- Mappings.
  local opts = { silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  --vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
--  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
--  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
--  vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer=bufnr,
  --   callback = function()
  --     local opts = {
  --       focusable = false,
  --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  --       border = 'rounded',
  --       source = 'always',  -- show source in diagnostic popup window
  --       prefix = ' '
  --     }
  --
  --     if not vim.b.diagnostics_pos then
  --       vim.b.diagnostics_pos = { nil, nil }
  --     end
  --
  --     local cursor_pos = vim.api.nvim_win_get_cursor(0)
  --     if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and
  --       #vim.diagnostic.get() > 0
  --     then
  --         vim.diagnostic.open_float(nil, opts)
  --     end
  --
  --     vim.b.diagnostics_pos = cursor_pos
  --   end
  -- })
  --
  -- Set some key bindings conditional on server capabilities
  -- if client.resolved_capabilities.document_formatting then
  --   vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
  -- end
  -- if client.resolved_capabilities.document_range_formatting then
  --   vim.keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
  -- end

end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason_lspconfig.setup()
mason_lspconfig.setup_handlers({
  -- Default handler
  function (server_name)
    lspconfig[server_name].setup{
      on_attach = custom_attach,
      capabilities = capabilities,
    }
  end,

  ["sumneko_lua"] = function ()
    lspconfig.sumneko_lua.setup({
      on_attach = custom_attach,
      capabilities = capabilities,

      settings = {
        Lua = {
          -- Tells lua that vim and use exist for nvim configuration
          diagnostics = {
            globals = { "vim", "use" },
          },
        },
      },
    })
  end,

  ["jdtls"] = function()
    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = os.getenv("HOME") .. "/.cache/jdtls/workspace/" .. project_name
    local mount_commands = function()
      local jdtls = require('jdtls')

      -- Set some keymaps for extra functionality
      vim.keymap.set("n", "<A-o>", function() jdtls.organize_imports() end)
      vim.keymap.set("n", "crv", function() jdtls.extract_variable() end)
      vim.keymap.set("v", "crv", function() jdtls.extract_variable(true) end)
      vim.keymap.set("n", "crc", function() jdtls.extract_variable() end)
      vim.keymap.set("v", "crc", function() jdtls.extract_variable(true) end)
      vim.keymap.set("v", "crm", function() jdtls.extract_method(true) end)

      require('jdtls.setup').add_commands()
    end
    local config = {
      -- The command that starts the language server
      filetypes = {"java"},
      autostart = true,
      on_attach = mount_commands,
      cmd = {

        'java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",

        '-configuration', jdtls_path .. "/config_linux",

        '-data', workspace_dir,
      },

      root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

      -- Here you can configure eclipse.jdt.ls specific settings
      settings = {
        java = {
          format = {
            enabled = true,
            settings = {
              url = vim.fn.stdpath("config") .. "/styleguides/java.xml",
              profile = "GoogleStyle",
            },
          },
        }
      },

      -- Language server `initializationOptions`
      -- You need to extend the `bundles` with paths to jar files
      -- if you want to use additional eclipse.jdt.ls plugins.
      init_options = {
        bundles = {
          vim.fn.stdpath("data") .. "/mason/packages/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.40.0.jar"
        }
      },
    }

    -- Create autocmd for launching jdtls on java filetype, similar to lspconfig implementation
    local lsp_group = vim.api.nvim_create_augroup('lspconfig', { clear = false })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        require("jdtls").start_or_attach(config)
      end,
      group = lsp_group,
      desc = 'Checks whether server jdtls should start a new instance or attach to an existing one.',
    })
  end
})


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

