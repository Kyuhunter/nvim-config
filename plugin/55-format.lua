local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({ "https://www.github.com/stevearc/conform.nvim" })

    require("conform").setup({
        formatters_by_ft = {
            lua = { "luaformat" },
            javascript = { "biome", stop_after_first = true },
            tex = { "latexindent" },
            xml = { "xmlformatter" },
        },
        formatters = {
            latexindent = {
                -- -m enables line-break changes; "when:after" counts the indentation into the 120 columns
                prepend_args = {
                    "-m",
                    "-y=modifyLineBreaks:textWrapOptions:columns:120,modifyLineBreaks:textWrapOptions:when:after",
                },
            },
            luaformat = {
                command = "lua-format",
                args = {
                    -- LuaFormatter off
                    '--extra-sep-at-table-end',
                    '--single-quote-to-double-quote',
                    '--spaces-inside-table-braces',
                    '--column-limit=120',
                    -- LuaFormatter on
                },
            },
        },
        format_on_save = function(bufnr)
            if vim.bo[bufnr].filetype == "tex" then
                return nil
            end

            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        format_after_save = function(bufnr)
            if vim.bo[bufnr].filetype == "tex" then
                return { timeout_ms = 10000, lsp_format = "fallback" }
            end
        end,
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
    vim.keymap.set("x", "<leader>F", ":Format<CR>", { silent = true, desc = "Format selection" })
end)
