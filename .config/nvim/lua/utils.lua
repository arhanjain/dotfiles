local M = {}

local fn = vim.fn


function M.executable(name)
	if fn.executable(name) > 0 then
		return true
	end
	
	return false
end

return M
