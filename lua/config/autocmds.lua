local autocmd = vim.api.nvim_create_autocmd
local whichkey = require("which-key")

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "run gofmt and goimports on save",
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = vim.api.nvim_create_augroup("goimports", {}),
})

autocmd("FileType", {
	desc = "Disable newline comments when inserting lines with o/O",
	callback = function()
		vim.opt_local.formatoptions:remove("o")
	end,
})

autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(e)
		local lspname = vim.lsp.get_client_by_id(e.data.client_id).name
		if lspname == "jdtls" then
			local ergoterm = require("ergoterm")
			local tasks = ergoterm.with_defaults({
				layout = "right",
				size = {
					right = "20%",
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
				name = "maven:compile",
				cmd = "mvn compile",
			})

			local _ = tasks:new({
				name = "maven:clean",
				cmd = "mvn clean",
			})

			local _ = tasks:new({
				name = "maven:compile:sources",
				cmd = "mvn compiler:compile",
			})

			local _ = tasks:new({
				name = "maven:compile:tests",
				cmd = "mvn compiler:tests",
			})

			local _ = tasks:new({
				name = "maven:test",
				cmd = "mvn test",
			})

			local task_list = ergoterm.filter_by_tag("task")
			whichkey.add({
				{
					"<leader>mv",
					function()
						ergoterm.select({
							terminals = task_list,
							prompt = "Run Task",
						})
					end,
					noremap = true,
					silent = true,
					desc = "Run Task",
				},
			})
		end
	end,
})
