vim.api.nvim_create_user_command("YankMarkdown", function()
	local ft = vim.bo.filetype

	-- Normalize range so start <= end
	local s = vim.fn.getpos("'<")
	local e = vim.fn.getpos("'>")

	local start_line, start_col = s[2], s[3]
	local end_line, end_col = e[2], e[3]

	-- Swap if selection was backwards
	if end_line < start_line or (end_line == start_line and end_col < start_col) then
		start_line, end_line = end_line, start_line
		start_col, end_col = end_col, start_col
	end

	-- Always get table of lines
	local lines = vim.fn.getline(start_line, end_line)
	if type(lines) == "string" then
		lines = { lines }
	end

	-- Clamp columns
	local function clamp_col(str, col)
		local len = #str
		if col < 1 then
			col = 1
		end
		if col > len then
			col = len
		end
		return col
	end

	-- Trim first line
	lines[1] = string.sub(lines[1], clamp_col(lines[1], start_col))

	-- Trim last line
	lines[#lines] = string.sub(lines[#lines], 1, clamp_col(lines[#lines], end_col))

	-- Wrap
	table.insert(lines, 1, string.format("```%s", ft))
	table.insert(lines, "```")

	vim.fn.setreg("+", table.concat(lines, "\n"))
end, { range = true })
