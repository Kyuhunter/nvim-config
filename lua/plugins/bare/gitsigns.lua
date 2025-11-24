return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local whichkey = require("which-key")

			whichkey.add({
                icon = {
                    icon = "",
                    color = "orange",
                },
				{
					"]c",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end,
					desc = "Next Hunk",
				},
				{
					"[c",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end,
                    desc = "Previous Hunk"
				},
				{
					"<leader>hs",
					function()
						gitsigns.stage_hunk()
					end,
					mode = "v",
                    desc = "Stage Hunk"
				},
				{
					"<leader>hr",
					function()
						gitsigns.reset_hunk()
					end,
					mode = "v",
                    desc = "Reset Hunk"
				},
				{
					"<leader>hs",
					function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
                    desc = "Stage Selection"
				},
				{
					"<leader>hr",
					function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
                    desc = "Reset Selection"
				},
				{
					"<leader>hS",
					function()
						gitsigns.stage_buffer()
					end,
                    desc = "Stage Buffer"
				},
				{
					"<leader>hR",
					function()
						gitsigns.reset_buffer()
					end,
                    desc = "Reset Buffer"
				},
				{
					"<leader>hp",
					function()
						gitsigns.preview_hunk()
					end,
                    desc = "Preview Hunk"
				},
				{
					"<leader>hi",
					function()
						gitsigns.preview_hunk_inline()
					end,
                    desc = "Preview Hunk Inline"
				},
				{
					"<leader>hb",
					function()
						gitsigns.blame_line({ full = true })
					end,
                    desc = "Blame Line"
				},
				{
					"<leader>hd",
					function()
						gitsigns.diffthis()
					end,
                    desc = "Diff Against Index"
				},
				{
					"<leader>hD",
					function()
						gitsigns.diffthis("~")
					end,
                    desc = "Diff Against Prev Commit"
				},
				{
					"<leader>hQ",
					function()
						gitsigns.setqflist("all")
					end,
                    desc = "All to QickFix"
				},
				{
					"<leader>hq",
					function()
						gitsigns.setqflist()
					end,
                    desc = "Buffer to QickFix"
				},
				-- Toggles
				{
					"\\tb",
					function()
						gitsigns.toggle_current_line_blame()
					end,
                    desc = "Toggle Current Line Blame"
				},
				{
					"\\tw",
					function()
						gitsigns.toggle_word_diff()
					end,
                    desc = "Toggle Word Diff"
				},
				-- Text object
				{
					"ih",
					function()
						gitsigns.select_hunk()
					end,
					mode = { "o", "x" },
                    desc = "Select Current Hunk"
				},
			})
		end,
	},
}
