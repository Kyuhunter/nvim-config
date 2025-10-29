return {
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
    }, {
        'mfussenegger/nvim-dap',
        lazy = true,
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {"nvim-neotest/nvim-nio"},
                opts = {}
            }, {
                'theHamsta/nvim-dap-virtual-text',
                opts = {enabled = true, virt_text_pos = 'eol'}
            }
        },
        keys = function()
            local dap = require("dap")
            return {
                {'<F5>', dap.continue, desc = "DAP continue"},
                {'<F10>', dap.step_over, desc = "Step Over"},
                {"<F11>", dap.step_into, desc = "Step Into"},
                {"<F12>", dap.step_out, desc = "Step Out"},
                {'<leader>b', dap.toggle_breakpoint, desc = "Toggle Breakpoint"},
                {'<leader>dd', ':lua require"dapui".toggle()<CR>'}
            }
        end,
        config = function()
            local dapui = require("dapui")
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

            -- JS, TS
            for _, adapter in pairs({"node", "chrome"}) do
                local pwa_adapter = "pwa-" .. adapter

                -- Handle launch.json configurations
                -- which specify type as "node" or "chrome"
                -- Inspired by https://github.com/StevanFreeborn/nvim-config/blob/main/lua/plugins/debugging.lua#L111-L123

                -- Main adapter
                dap.adapters[pwa_adapter] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "js-debug-adapter",
                        args = {"${port}"}
                    },
                    enrich_config = function(config, on_config)
                        -- Under the hood, always use the main adapter
                        config.type = pwa_adapter
                        on_config(config)
                    end
                }

                -- Dummy adapter, redirects to the main one
                dap.adapters[adapter] = dap.adapters[pwa_adapter]
            end
            dap.adapters.python = function(cb, config)
                if config.request == "attach" then
                    ---@diagnostic disable-next-line: undefined-field
                    local port = (config.connect or config).port
                    ---@diagnostic disable-next-line: undefined-field
                    local host = (config.connect or config).host or "localhost"
                    cb({
                        type = "server",
                        port = assert(port,
                                      "`connect.port` is required for a python `attach` configuration"),
                        host = host
                    })
                else
                    cb({type = "executable", command = "debugpy-adapter"})
                end
            end

            -- The python adapter is deprecated, see nvim-dap-python#129
            dap.adapters.debugpy = dap.adapters.python
        end
    }, {
        -- golang debugging
        'leoluz/nvim-dap-go',
        lazy = true,
        ft = "go",
        opts = {}
    }, {
        -- rust debugging
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false -- This plugin is already lazy
    }
}
