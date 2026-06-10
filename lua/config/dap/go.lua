local dap = require("dap")

local function dlv_command()
    local mason_dlv = vim.fn.stdpath("data") .. "/mason/bin/dlv"
    if vim.fn.executable(mason_dlv) == 1 then
        return mason_dlv
    end

    return "dlv"
end

local function get_arguments()
    return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = "Args: " }, function(input)
            local args = {}
            if input and input ~= "" then
                args = vim.split(input, " ", { trimempty = true })
            end
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

local function get_build_flags()
    return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = "Build flags: " }, function(input)
            local flags = {}
            if input and input ~= "" then
                flags = vim.split(input, " ", { trimempty = true })
            end
            coroutine.resume(dap_run_co, flags)
        end)
    end)
end

dap.adapters.go = function(callback, config)
    if config.request == "attach" and config.mode == "remote" then
        callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or 38697,
        })
        return
    end

    callback({
        type = "server",
        port = "${port}",
        executable = {
            command = dlv_command(),
            args = { "dap", "-l", "127.0.0.1:${port}" },
            detached = vim.fn.has("win32") == 0,
        },
        options = {
            initialize_timeout_sec = 20,
        },
    })
end

dap.configurations.go = {
    {
        type = "go",
        request = "launch",
        mode = "debug",
        name = "Debug current file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "launch",
        mode = "debug",
        name = "Debug current file with args",
        program = "${file}",
        args = get_arguments,
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "launch",
        mode = "debug",
        name = "Debug package",
        program = "${fileDirname}",
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "launch",
        mode = "debug",
        name = "Debug package with build flags",
        program = "${fileDirname}",
        buildFlags = get_build_flags,
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "launch",
        mode = "test",
        name = "Debug test file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "launch",
        mode = "test",
        name = "Debug package tests",
        program = "./${relativeFileDirname}",
        cwd = "${workspaceFolder}",
        outputMode = "remote",
    },
    {
        type = "go",
        request = "attach",
        mode = "local",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
    },
    {
        type = "go",
        request = "attach",
        mode = "remote",
        name = "Attach remote",
        host = function()
            local host = vim.fn.input("Delve host: ", "127.0.0.1")
            return host ~= "" and host or "127.0.0.1"
        end,
        port = function()
            return tonumber(vim.fn.input("Delve port: ", "38697")) or 38697
        end,
    },
}
