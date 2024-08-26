return {
	{
		"rose-pine/neovim", 
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme rose-pine]])
		end,
	},
	{ 
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = 'nvim-lua/plenary.nvim' 
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate"
	},
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = 'nvim-lua/plenary.nvim'
	},
	{
		'mbbill/undotree'
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x'
	},
	{
		'neovim/nvim-lspconfig'
	},
	{
		'hrsh7th/nvim-cmp'
	},
	{
		'hrsh7th/cmp-nvim-lsp',
		lazy = false,
		priority = 999
	},
	{
		'williamboman/mason.nvim'
	},
	{
		'williamboman/mason-lspconfig.nvim'
	},
    {
        'lewis6991/gitsigns.nvim',
        opts = {}
    },
    {
        'tpope/vim-fugitive',
    },
}
