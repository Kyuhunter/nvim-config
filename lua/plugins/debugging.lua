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
        opts = {
            enabled = true,
            virt_text_pos = 'eol',
        },
    },
    {
        "jonboh/nvim-dap-rr",
        dependencies = {"nvim-dap", "telescope.nvim"},
        lazy = true,
        opts = {
            mappings = {
                continue = '<F5>',
                step_over = '<F10>',
                step_into = '<F11>',
                step_out = '<F12>',
                reverse_continue = '<F17>',
                reverse_step_over = '<F22>',
                reverse_step_into = '<F23>',
                reverse_step_out = '<F24>',
                step_over_i = '<F34>',
                step_into_i = '<F35>',
                step_out_i = '<F36>',
                reverse_step_over_i = '<F46>',
                reverse_step_into_i = '<F47>',
                reverse_step_out_i = '<F48>',
            }
        },
    },
    {
        'mfussenegger/nvim-dap',
        lazy = true,
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

            local cpptools_path = vim.fn.stdpath('data')..'/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
            dap.adapters.cppdbg = {
                id = 'cppdbg',
                type = 'executable',
                command = cpptools_path,
            }

            local rr_dap = require('nvim-dap-rr')

            -- LLDB debugger for C, C Derivatives and Rust
            dap.adapters["lldb"] = function(adapter_callback, config, parent)
                adapter_callback {
                    id = 'lldb',
                    type = 'executable',
                    command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- must be absolute path
                }
            end

            -- Rust config
            dap.configurations.rust = { rr_dap.get_rust_config({
                type = 'lldb',
                name = 'Lauch',
                request = 'launch',
                cwd = '${workspaceFolder}',
            })}

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
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        lazy = true,
        opts = {},
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
