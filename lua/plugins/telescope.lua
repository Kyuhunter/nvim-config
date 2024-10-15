return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        cmd = 'Telescope',
        lazy = true,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        keys = {
            { '<leader>pf', require('telescope.builtin').find_files },
            { '<C-p>', require('telescope.builtin').git_files },
            { '<leader>ps', function ()
                require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") });
            end },
            { '<leader>pg', require('telescope.builtin').live_grep },
            { '<leader>pi', require('telescope.builtin').current_buffer_fuzzy_find },
        },
        config = function()
            local open_with_trouble = function(...)
                return require("trouble.sources.telescope").open(...)
            end

            local telescope = require('telescope')
            telescope.setup{
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                    }
                },
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is available.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                },
                mappings = {
                    i = {
                        ["<c-t>"] = open_with_trouble,
                        ["<a-t>"] = open_with_trouble,
                    },
                },
            }

            telescope.load_extension("file_browser")
        end,
    },
}
