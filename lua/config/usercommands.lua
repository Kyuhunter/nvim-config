vim.api.nvim_create_user_command("YankMarkdown", function()
	local filetype = vim.bo.filetype
	local fence = "```"

	local mode = vim.api.nvim_get_mode().mode
	local opts = {}
	if mode == "v" or mode == "V" or mode == "\22" then
		opts.type = mode
	end
	local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), opts), "\n")

	local output = fence .. filetype .. "\n" .. text .. "\n" .. fence

	-- Yank to + register
	vim.fn.setreg("+", output)

	vim.notify("Yanked to clipboard with markdown formatting")
end, { range = true })
