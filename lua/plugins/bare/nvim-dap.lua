return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			opts = {},
		},
		{ "theHamsta/nvim-dap-virtual-text" },
		{
			{
				-- lazydev.nvim is a plugin that properly configures LuaLS for editing
				-- your Neovim config by lazily updating your workspace libraries.
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				dependencies = {
					"Bilal2453/luvit-meta", -- optional 'vim.uv' typings
				},
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
						{ plugins = { "nvim-dap-ui" }, types = true },
					},
				},
				lazy = true,
			},
		},
	},
	keys = {
		{
			"<F1>",
			function()
				require("dap.ui.widgets").hover(nil, { border = "rounded" })
			end,
			desc = "DAP Hover",
		},
		{ "<F4>", "<cmd>DapTerminate<cr>", desc = "DAP Terminate" },
		{ "<F5>", "<cmd>DapContinue<cr>", desc = "DAP continue" },
		{ "<F6>", "<cmd>DapRunToCursor<cr>", desc = "Run to Cursor" },
		{ "<F10>", "<cmd>DapStepOver<cr>", desc = "Step Over" },
		{ "<F11>", "<cmd>DapStepInto<cr>", desc = "Step Into" },
		{ "<F12>", "<cmd>DapStepOut<cr>", desc = "Step Out" },
		{
			"<leader>b",
			"<cmd>DapToggleBreakpoint<cr>",
			desc = "Toggle Breakpoint",
		},
		{
			"<F24>",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle DAP UI",
		},
	},
	config = function()
        -- Virtual Text
        require("plugins.dap.dap-virtual-text")

		-- UI config
		require("plugins.dap.dap-ui")

		-- Adapters
		--
		-- JS, TS
		require("plugins.dap.js-debug-adapter")
		-- Python
		require("plugins.dap.debugpy")
	end,
}
