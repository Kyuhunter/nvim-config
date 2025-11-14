return {
	{
		"olrtg/nvim-emmet",
		event = "InsertEnter",
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		opts = {
			automatic_enable = {
				exclude = { "java", "java_language_server", "jdtls" },
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{ "folke/lazydev.nvim", ft = "lua" },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = "mason-org/mason.nvim",
        opts = {
			-- LuaFormatter off
			ensure_installed = {
				-- Formatting
                "prettierd",
				-- Lua
				"lua_ls",
				"luaformatter",
				-- Java
				"jdtls",
				"java-debug-adapter",
				"java-test",
                "checkstyle",
				-- Angular
				"angularls",
				"ts_ls",
				"emmet_language_server",
				"eslint",
			},
			-- LuaFormatter on
        },
    }
}
