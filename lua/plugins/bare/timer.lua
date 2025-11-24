return {
	"temelgunaydin/timer.nvim",
	opts = {
		options = { 5, 10, 25, 45, 55 }, -- customize durations
	},
	config = function()
		local whichkey = require("which-key")
		whichkey.add({
			{
				"<leader>t",
				group = "Timer",
				icon = {
					icon = "󰄉",
				},
			},
			{
				"<leader>tf",
				function()
					require("timer").pick_and_start()
				end,
				desc = "Open Timer Duration Picker",
			},
			{
				"<leader>tr",
				function()
					require("timer").showRemainingTime()
				end,
				desc = "Show Timer Remaining",
			},
		})
	end,
}
