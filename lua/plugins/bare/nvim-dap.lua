return {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {"nvim-neotest/nvim-nio"},
            opts = {}
        }, {'theHamsta/nvim-dap-virtual-text', opts = {}}, {
            {
                -- lazydev.nvim is a plugin that properly configures LuaLS for editing 
                -- your Neovim config by lazily updating your workspace libraries. 
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                dependencies = {
                    "Bilal2453/luvit-meta" -- optional 'vim.uv' typings
                },
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        {path = "luvit-meta/library", words = {"vim%.uv"}},
                        {plugins = {"nvim-dap-ui"}, types = true}
                    }
                },
                lazy = true
            }
        }
    },
    keys = function()
        local dap = require("dap")
        return {
            {
                "<F1>",
                function()
                    require("dap.ui.widgets").hover(nil, {border = "rounded"})
                end,
                desc = "DAP Hover"
            }, {"<F4>", "<CMD>DapTerminate<CR>", desc = "DAP Terminate"},
            {'<F5>', dap.continue, desc = "DAP continue"},
            {
                "<F6>",
                function() require("dap").run_to_cursor() end,
                desc = "Run to Cursor"
            }, {'<F10>', dap.step_over, desc = "Step Over"},
            {"<F11>", dap.step_into, desc = "Step Into"},
            {"<F12>", dap.step_out, desc = "Step Out"},
            {'<leader>b', dap.toggle_breakpoint, desc = "Toggle Breakpoint"},
            {'<leader>dd', ':lua require"dapui".toggle()<CR>'}
        }
    end,
    config = function()
        -- UI config
        require("plugins.dap.dap-ui")

        -- Adapters
        --
        -- JS, TS
        require("plugins.dap.js-debug-adapter")
        -- Python
        require("plugins.dap.debugpy")
    end
}
