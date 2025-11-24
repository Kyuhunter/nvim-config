local wk = require("which-key")
wk.add({
	{
		{ "<leader>y", '"+y', desc = "yank to clipboard" },
		{ "<leader>Y", '"+Y', desc = "yank to EOL to clipboard" },
		{
			"<leader>y",
			'"+y',
			desc = "yank to clipboard",
			mode = "v",
		},
		{ "<C-d>", "<C-d>zz", desc = "Page Down (centered)" },
		{ "<C-u>", "<C-u>zz", desc = "Page Up (centered)" },
		{
			"n",
			"nzzzv",
			desc = "next search result",
			group = "Navigation",
		},
		{
			"N",
			"Nzzzv",
			desc = "previous search result",
			group = "Navigation",
		},
		{
			"<leader>s",
			[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
			desc = "search and replace under cursor",
		},
		{ "<leader>mx", "<cmd>!chmod +x %<CR>", desc = "make current file executable", { silent = true } },
	},
	{
		mode = "v",
		{ "J", ":m '>+1<CR>gv=gv", desc = "move line down (autoindent)" },
		{ "K", ":m '<-2<CR>gv=gv", desc = "move line up (autoindent)" },
		{ "<leader>M", "<cmd>YankMarkdown<CR>", desc = "Yank as Markdown" },
	},
})
