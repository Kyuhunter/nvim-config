return {
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
                opts = {},
            },
            {
                'theHamsta/nvim-dap-virtual-text',
                opts = {
                    enabled = true,
                    virt_text_pos = 'eol',
                },
            },
        },
        keys = {
            { '<F5>', ':lua require"dap".continue()<CR>' },
            { '<F10>', ':lua require"dap".step_over()<CR>' },
            { '<F11>', ':lua require"dap".step_into()<CR>' },
            { '<F12>', ':lua require"dap".step_out()<CR>' },
            { '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>' },
            { '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))()<CR>'},
            { '<leader>lp', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))()<CR>'},
            { '<leader>dr', ':lua require"dap".repl.open()<CR>'},
            { '<leader>dd', ':lua require"dapui".toggle()<CR>'},
        },
        config = function()
            local dapui =  require("dapui")
            local dap = require("dap")

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
    {
        -- lazydev.nvim is a plugin that properly configures LuaLS for editing 
        -- your Neovim config by lazily updating your workspace libraries. 
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        dependencies = {
            "Bilal2453/luvit-meta", -- optional 'vim.uv' typings
        },
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
        -- golang debugging
        'leoluz/nvim-dap-go',
        lazy = true,
        ft = "go",
        opts = {},
    },
    {
        -- rust debugging
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
    }
}
