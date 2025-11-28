return {
    "necrom4/calcium.nvim",
    cmd = { "Calcium" },
    opts = {
        -- default configuration
        notifications = true, -- notify result
        default_mode = "append", -- or `replace` the expression
    },
    keys = {
        -- example keymap
        {
            "<leader><CR>",
            ":Calcium<CR>",
            desc = "Calculate",
            mode = { "n", "v" },
            silent = true,
        },
    },
}
