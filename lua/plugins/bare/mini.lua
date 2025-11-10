return {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
        -- require('mini.pick').setup({})
        -- vim.keymap.set("n", "<leader>pf", "<cmd>Pick files<CR>",
        --                {desc = "Open file picker"})
        -- vim.keymap.set("n", "<leader>pg", "<cmd>Pick grep_live<CR>",
        --                {desc = "Open file picker with grep"})
        require('mini.snippets').setup({})
        require('mini.icons').setup({})
        require('mini.pairs').setup({})
        require('mini.basics').setup({})
        require('mini.extra').setup({})
        require('mini.surround').setup({})
        require('mini.comment').setup({})
    end
}
