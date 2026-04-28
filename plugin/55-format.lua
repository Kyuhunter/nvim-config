local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({ "https://www.github.com/stevearc/conform.nvim" })

    require("conform").setup({
        formatters_by_ft = {
            lua = { "luaformat" },
            javascript = { "biome", stop_after_first = true },
            xml = { "xmlformatter" },
        },
        formatters = {
            luaformat = {
                command = "lua-format",
                args = {
                    -- LuaFormatter off
                    '--extra-sep-at-table-end',
                    '--single-quote-to-double-quote',
                    '--spaces-inside-table-braces',
                    -- LuaFormatter on
                },
            },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    })

    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1,
                args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({
            async = true,
            lsp_format = "fallback",
            range = range,
        })
    end, { range = true })

    vim.keymap.set("n", "<leader>F", "<cmd>Format<CR>", { desc = "Format buffer" })
end)
