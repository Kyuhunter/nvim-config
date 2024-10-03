return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
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
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    }, -- optional `vim.uv` typings
    {
        'theHamsta/nvim-dap-virtual-text',
    },
    {
        "jonboh/nvim-dap-rr",
        dependencies = {"nvim-dap", "telescope.nvim"},
    },
    {
        'mfussenegger/nvim-dap',
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
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
    },
}
