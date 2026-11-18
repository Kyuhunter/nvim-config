---@diagnostic disable: undefined-global
local dapui = require("dapui")
local dap = require("dap")

dapui.setup({})

dap.listeners.after.event_initialized.dapui_config = function()
	dapui.open()
end

local function set_dap_hl()
	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#FF0000" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
end
set_dap_hl() -- loaded lazily, after the colorscheme is already set
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	desc = "prevent colorscheme clears self-defined DAP icon colors.",
	callback = set_dap_hl,
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = " ﳁ", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped" })
