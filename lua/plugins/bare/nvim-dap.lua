return {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {"nvim-neotest/nvim-nio"},
            opts = {}
        }, {'theHamsta/nvim-dap-virtual-text'}, {
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
    keys = {
        {
            "<F1>",
            function()
                require("dap.ui.widgets").hover(nil, {border = "rounded"})
            end,
            desc = "DAP Hover"
        }, {"<F4>", "<cmd>DapTerminate<cr>", desc = "DAP Terminate"},
        {"<F5>", "<cmd>DapContinue<cr>", desc = "DAP continue"},
        {"<F6>", "<cmd>DapRunToCursor<cr>", desc = "Run to Cursor"},
        {"<F10>", "<cmd>DapStepOver<cr>", desc = "Step Over"},
        {"<F11>", "<cmd>DapStepInto<cr>", desc = "Step Into"},
        {"<F12>", "<cmd>DapStepOut<cr>", desc = "Step Out"},
        {
            "<leader>b",
            "<cmd>DapToggleBreakpoint<cr>",
            desc = "Toggle Breakpoint"
        }, {"<leader>dd", "<cmd>DapUIToggle<cr>", desc = "Toggle DAP UI"}
    },
    config = function()
        local present_virtual_text, dap_vt = pcall(require,
                                                   "nvim-dap-virtual-text")

        dap_vt.setup({
            enabled = true, -- enable this plugin (the default)
            enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true, -- show stop reason when stopped for exceptions
            commented = false, -- prefix virtual text with comment string
            only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
            all_references = false, -- show virtual text on all all references of the variable (not only definitions)
            filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
            -- Experimental Features:
            virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
            all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
            virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
        })

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
