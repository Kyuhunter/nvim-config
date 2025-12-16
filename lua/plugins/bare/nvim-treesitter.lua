return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	opts = {
		-- LazyVim config for treesitter
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = true },
	},
}
