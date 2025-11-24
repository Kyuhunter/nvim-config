return {
	"waiting-for-dev/ergoterm.nvim",
	opts = {
		picker = {
			picker = "telescope",
			extra_select_actions = {
				["<C-d>"] = {
					fn = function(term)
						term:cleanup()
					end,
					desc = "Delete terminal",
				},
			},
		},
	},
	config = function()
		local wk = require("which-key")
		local tasks = require("ergoterm").with_defaults({
			layout = "right",
			size = {
				right = "25%",
			},
			tags = { "task" },
			auto_list = false,
			bang_target = false,
			sticky = true,
			auto_scroll = true,
			default_action = function(term)
				term:open()
			end,
		})
		local _ = tasks:new({
			name = "maven:init",
			cmd = "mvn archetype:generate "
				.. "-DarchetypeGroupId=dev.olschimke.archetypes "
				.. "-DarchetypeArtifactId=java-25-quickstart "
				.. "-DarchetypeVersion=1.0.0-SNAPSHOT "
				.. "-DgroupId=dev.olschimke "
		})
		wk.add({
			"<leader>e",
			function()
				require("ergoterm").select({
					terminals = require("ergoterm").filter_by_tag("task"),
					prompt = "Run Task",
				})
			end,
			noremap = true,
			silent = true,
			desc = "Run Task",
		})
	end,
}
