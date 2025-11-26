return {
	"mrjones2014/smart-splits.nvim",
	build = "./kitty/install-kittens.bash",
	lazy = false,
	opts = {
		at_edge = "stop",
		kitty_password = "kitty_password",
	},
	config = function()
		local whichkey = require("which-key")
		whichkey.add({
			{
				icon = {
					icon = "󰩨",
				},
				{
					"<C-H>",
					function()
						require("smart-splits").resize_left(10)
					end,
					desc = "Resize Left",
				},
				{
					"<C-J>",
					function()
						require("smart-splits").resize_down()
					end,
					desc = "Resize Down",
				},
				{
					"<C-K>",
					function()
						require("smart-splits").resize_up()
					end,
					desc = "Resize Right",
				},
				{
					"<C-L>",
					function()
						require("smart-splits").resize_right()
					end,
					desc = "Resize Right",
				},
			},
			-- moving between splits
			{
				icon = {
					icon = "",
				},
				{
					"<C-h>",
					function()
						require("smart-splits").move_cursor_left()
					end,
					desc = "Move Cursor Left",
				},
				{
					"<C-j>",
					function()
						require("smart-splits").move_cursor_down()
					end,
					desc = "Move Cursor Down",
				},
				{
					"<C-k>",
					function()
						require("smart-splits").move_cursor_up()
					end,
					desc = "Move Cursor Up",
				},
				{
					"<C-l>",
					function()
						require("smart-splits").move_cursor_right()
					end,
					desc = "Move Cursor Right",
				},
				{
					"<C-\\>",
					function()
						require("smart-splits").move_cursor_previous()
					end,
					desc = "Move Cursor to Previous Split",
				},
			},
			-- swapping buffers between windows
			{
				icon = {
					icon = "",
				},
				{
					"<leader><leader>h",
					function()
						require("smart-splits").swap_buf_left()
					end,
					desc = "Swap Buffer Left",
				},
				{
					"<leader><leader>j",
					function()
						require("smart-splits").swap_buf_down()
					end,
					desc = "Swap Buffer Down",
				},
				{
					"<leader><leader>k",
					function()
						require("smart-splits").swap_buf_up()
					end,
					desc = "Swap Buffer Up",
				},
				{
					"<leader><leader>l",
					function()
						require("smart-splits").swap_buf_right()
					end,
					desc = "Swap Buffer Right",
				},
			},
		})
	end,
}
