return {
	"apdot/doodle",
	dependencies = {
		"kkharji/sqlite.lua",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		settings = {
			-- This is the only required setting for sync to work.
			-- Set it to the absolute path of your private notes repository.
			git_repo = os.getenv("HOME") .. "/notes",
			sync = true,
		},
	},
	keys = {
        {
            "<leader>dh",
            function ()
               require("doodle"):here()
            end,
            desc = "Doodle Here"
        },
		{
			"<leader>dv",
			function()
				require("doodle"):toggle_finder()
			end,
			desc = "Doodle Finder",
		},
		{
			"<leader>ds",
			function()
				require("doodle"):sync()
			end,
			desc = "Doodle Sync",
		},
		{
			"<leader>dl",
			function()
				require("doodle"):toggle_links()
			end,
			desc = "Doodle Links",
		},
		{
			"<leader>dg",
			function()
				require("doodle"):graph_view()
			end,
			desc = "Doodle Graph View",
		},
	},
}
