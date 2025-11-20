local builtin = require("telescope.builtin")

---@module "telescope"
return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "apdot/doodle" },
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			extensions = {
				doodle = {},
			},
		})

		telescope.load_extension("doodle")
	end,
	keys = {
		{
			"<leader>pf",
			builtin.find_files,
			desc = "Telescope find files",
		},
		{
			"<leader>pg",
			builtin.live_grep,
			desc = "Telescope live grep",
		},
		{
			"<leader>pb",
			builtin.buffers,
			desc = "Telescope list buffers",
		},
		{
			"<leader>pd",
			builtin.diagnostics,
			desc = "Telescope list diagnostics",
		},
		{
			"<leader>dfn",
			function()
				require("telescope").extensions.doodle.find_notes()
			end,
			desc = "Doodle Find Notes",
		},
		{
			"<leader>dff",
			function()
				require("telescope").extensions.doodle.find_files()
			end,
			desc = "Doodle Find Files",
		},
		{
			"<leader>dft",
			function()
				require("telescope").extensions.doodle.find_templates()
			end,
			desc = "Doodle Find Templates",
		},
	},
}
