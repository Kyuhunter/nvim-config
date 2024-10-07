return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        lazy = true,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { plugins = { "nvim-dap-ui" }, types = true },
            },
        },
        lazy = true,
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    }, -- optional `vim.uv` typings
    {
        'theHamsta/nvim-dap-virtual-text',
        lazy = true,
    },
    {
        "jonboh/nvim-dap-rr",
        dependencies = {"nvim-dap", "telescope.nvim"},
        lazy = true,
    },
    {
        'mfussenegger/nvim-dap',
        lazy = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        lazy = true,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { plugins = { "nvim-dap-ui" }, types = true },
            },
        },
        lazy = true,
    },
}
