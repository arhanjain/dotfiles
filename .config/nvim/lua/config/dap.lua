-- Icons changes
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

local dap = require('dap')
local dapui = require('dapui')


require("dap-python").setup()
require("jdtls").setup_dap({hotcodereplace = "auto"})
dapui.setup()


-- Event listeners
dap.listeners.after.event_initialized["dapui-config"] = function() dapui.open() end
dap.listeners.after.event_terminated["dapui-config"] = function() dapui.close() end
dap.listeners.after.event_exited["dapui-config"] = function() dapui.close() end


