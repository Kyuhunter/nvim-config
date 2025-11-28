-- For `plugins/markview.lua` users.
return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	-- Completion for `blink.cmp`
	dependencies = { "saghen/blink.cmp" },
	---@class markview.config
	opts = {
		preview = {
			icon_provider = "mini",
			enable = false,
		},
	},
	init = function()
		local whichkey = require("which-key")

		whichkey.add({
			{
				"<leader>mt",
				function()
					require("markview.commands").Toggle()
				end,
				desc = "Markview Toggle",
			},
			{
				"<leader>ms",
				function()
					require("markview.autocmds").splitToggle()
				end,
				desc = "Markview Toggle Splitview",
			},
		})
	end,
}
