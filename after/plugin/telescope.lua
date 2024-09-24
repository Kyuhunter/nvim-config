local vim = vim;
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add
-- Setup
require('telescope').setup({
    extensions = {
        file_browser = {
            hijack_netrw = true,
        }
    },
    defaults = {
        mappings = {
            i = {
                ['<C-t>'] = open_with_trouble,
            },
            n = {
                ['<C-t>'] = open_with_trouble,
            },
        }
    }
})

-- Keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pi', builtin.current_buffer_fuzzy_find, {})

-- Telescope Extensions
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'remote-sshfs'
--require('telescope').load_extension 'dap'
