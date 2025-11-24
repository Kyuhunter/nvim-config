return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = { watch_for_changes = true },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "<leader>pv", "<cmd>Oil<CR>", desc = "Open Oil in current Buffer" },
		{ "-", "<cmd>Oil<CR>", desc = "Open Oil in current Buffer" },
	},
}
