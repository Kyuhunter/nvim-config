---@diagnostic disable: undefined-global
local dap = require("dap")
local M = {}

local function has_config(configs, name)
    for _, config in ipairs(configs) do
        if config.name == name then
            return true
        end
    end

    return false
end

local function resolve_current_classname()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        return nil
    end

    local class_name = vim.fn.fnamemodify(file, ":t:r")
    if class_name == "" then
        return nil
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        local package_name = line:match("^%s*package%s+([%w_.]+)%s*;")
        if package_name and package_name ~= "" then
            return package_name .. "." .. class_name
        end
    end

    return class_name
end

function M.ensure_adapter()
    if dap.adapters.java then
        return true
    end

    local ok, jdtls = pcall(require, "jdtls")
    if not ok then
        return false
    end

    local setup_ok = pcall(jdtls.setup_dap, {
        hotcodereplace = "auto",
        config_overrides = {},
    })
    if not setup_ok then
        return false
    end

    return dap.adapters.java ~= nil
end

function M.ensure_configs()
    dap.configurations.java = dap.configurations.java or {}

    if not has_config(dap.configurations.java, "Launch Java main class") then
        table.insert(dap.configurations.java, {
            type = "java",
            request = "launch",
            name = "Launch Java main class",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            mainClass = function()
                return vim.fn.input("Main class (e.g. com.example.Main): ")
            end,
            projectName = "",
        })
    end

    if not has_config(dap.configurations.java, "Launch nearest class") then
        table.insert(dap.configurations.java, {
            type = "java",
            request = "launch",
            name = "Launch nearest class",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            mainClass = function()
                local class_name = resolve_current_classname()
                if class_name and class_name ~= "" then
                    return class_name
                end

                return vim.fn.input("Main class (e.g. com.example.Main): ")
            end,
            projectName = "",
        })
    end

    if not has_config(dap.configurations.java, "Attach to remote JVM (:5005)") then
        table.insert(dap.configurations.java, {
            type = "java",
            request = "attach",
            name = "Attach to remote JVM (:5005)",
            hostName = "127.0.0.1",
            port = function()
                local port = tonumber(vim.fn.input("JVM debug port: ", "5005"))
                return port or 5005
            end,
        })
    end
end

return M
