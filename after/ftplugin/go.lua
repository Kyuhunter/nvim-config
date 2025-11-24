local whichkey = require("which-key")
whichkey.add({
	{ "<leader>ee", "if err != nil {<CR>panic(err)<CR>}<CR>", desc = "Insert Error Handling" },
})
