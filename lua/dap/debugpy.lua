local dap = require("dap")

local function debugpy_adapter_command()
    if vim.fn.executable("debugpy-adapter") == 1 then
        return {
            command = "debugpy-adapter",
            args = {},
        }
    end

    if vim.fn.executable("python3") == 1 then
        return {
            command = "python3",
            args = { "-m", "debugpy.adapter" },
        }
    end

    return {
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }
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
        local adapter = debugpy_adapter_command()
        cb({
            type = "executable",
            command = adapter.command,
            args = adapter.args,
        })
    end
end
-- The python adapter is deprecated, see nvim-dap-python#129
dap.adapters.debugpy = dap.adapters.python

dap.configurations.python = dap.configurations.python or {
    {
        type = "debugpy",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
    },
    {
        type = "debugpy",
        request = "launch",
        name = "Launch module",
        module = function()
            return vim.fn.input("Module name: ")
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
    },
    {
        type = "debugpy",
        request = "attach",
        name = "Attach (localhost:5678)",
        connect = {
            host = "127.0.0.1",
            port = 5678,
        },
    },
}
