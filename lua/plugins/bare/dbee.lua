return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	config = function()
		local dbee = require("dbee")
		local whichkey = require("which-key")
		require("dbee").setup({
			sources = {
				require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistance.json"),
			},
		})
		whichkey.add({
			{
				"<leader>s",
				group = "DBee",
				icon = {
					icon = "",
				},
			},
			{
				"<leader>so",
				function()
					dbee.open()
				end,
				desc = "Open DBee",
			},
			{
				"<leader>st",
				function()
					dbee.toggle()
				end,
				desc = "Toggle DBee",
			},
			{
				"<leader>sc",
				function()
					dbee.close()
				end,
				desc = "Close DBee",
			},
		})
	end,
}
