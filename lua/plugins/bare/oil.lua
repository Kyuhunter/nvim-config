return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {watch_for_changes = true},
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    init = function()
        vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>",
                       {desc = "Open Oil in current buffer"})
        vim.keymap.set("n", "-", "<cmd>Oil<CR>",
                       {desc = "Open Oil in current Buffer"})

    end
}
