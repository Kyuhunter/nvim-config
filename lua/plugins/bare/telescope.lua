---@module "telescope"
return {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    keys = function()
        local builtin = require('telescope.builtin')
        return {
            {"<leader>pf", builtin.find_files, {desc = "Telescope find files"}},
            {"<leader>pg", builtin.live_grep, {desc = "Telescope live grep"}},
            {"<leader>pb", builtin.buffers, {desc = "Telescope list buffers"}},
            {"<leader>pd", builtin.diagnostics, {desc = "Telescope list diagnostics"}},
        }
    end
}
