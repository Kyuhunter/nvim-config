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

local function resolve_classname_from_file(file)
    if not file or file == "" then
        return nil
    end

    local class_name = vim.fn.fnamemodify(file, ":t:r")
    if class_name == "" then
        return nil
    end

    local lines = vim.fn.readfile(file, "", 200)
    for _, line in ipairs(lines) do
        local package_name = line:match("^%s*package%s+([%w_.]+)%s*;")
        if package_name and package_name ~= "" then
            return package_name .. "." .. class_name
        end
    end

    return class_name
end

local function resolve_current_classname()
    local file = vim.api.nvim_buf_get_name(0)
    return resolve_classname_from_file(file)
end

local function trim(value)
    return vim.trim(value or "")
end

local function is_owned_java_launch(config)
    return config and config.__jdtls_java_launch == true
end

local function mark_owned_java_launch(config)
    config.__jdtls_java_launch = true
    return config
end

local root_markers = {
    { "mvnw", "gradlew" },
    { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" },
    { ".git" },
}

local function find_project_root()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        path = vim.uv.cwd()
    end

    -- Prefer the deepest project-like folder to avoid launching from repo root.
    for dir in vim.fs.parents(path) do
        for _, sub in ipairs({ "src/main/java", "src/test/java" }) do
            local stat = vim.uv.fs_stat(dir .. "/" .. sub)
            if stat and stat.type == "directory" then
                return dir
            end
        end
    end

    for _, group in ipairs(root_markers) do
        local root = vim.fs.root(0, group)
        if root then
            return root
        end
    end

    return vim.uv.cwd()
end

local function find_preferred_mainclass()
    local root = find_project_root()
    if not root or root == "" then
        return nil
    end

    local search_paths = {
        root .. "/src/main/java",
        root .. "/src",
        root,
    }

    for _, filename in ipairs({ "Main.java", "App.java" }) do
        for _, base in ipairs(search_paths) do
            local stat = vim.uv.fs_stat(base)
            if stat and stat.type == "directory" then
                local matches = vim.fs.find(filename, {
                    path = base,
                    upward = false,
                    type = "file",
                    limit = 1,
                })

                local file = matches and matches[1]
                if file then
                    local class_name = resolve_classname_from_file(file)
                    if class_name and class_name ~= "" then
                        return class_name
                    end
                end
            end
        end
    end

    return nil
end

local function get_launch_store_path(root)
    return vim.fs.joinpath(root, ".nvim", "jdtls-main-classes.json")
end

local function read_stored_mainclasses(root)
    local file = io.open(get_launch_store_path(root), "r")
    if not file then
        return {}
    end

    local content = file:read("*a")
    file:close()

    if trim(content) == "" then
        return {}
    end

    local ok, decoded = pcall(vim.json.decode, content)
    if not ok or type(decoded) ~= "table" then
        return {}
    end

    local classes = decoded.classes
    if type(classes) ~= "table" then
        return {}
    end

    local seen = {}
    local result = {}
    for _, class_name in ipairs(classes) do
        class_name = trim(class_name)
        if class_name ~= "" and not seen[class_name] then
            seen[class_name] = true
            table.insert(result, class_name)
        end
    end

    return result
end

local function save_stored_mainclass(root, class_name)
    class_name = trim(class_name)
    if class_name == "" then
        return
    end

    local classes = read_stored_mainclasses(root)
    local result = { class_name }
    for _, stored in ipairs(classes) do
        if stored ~= class_name then
            table.insert(result, stored)
        end
    end

    local path = get_launch_store_path(root)
    vim.fn.mkdir(vim.fs.dirname(path), "p")

    local file = assert(io.open(path, "w"))
    file:write(vim.json.encode({ classes = result }) .. "\n")
    file:close()
end

local function resolve_launch_mainclass()
    local preferred_main = find_preferred_mainclass()
    if preferred_main and preferred_main ~= "" then
        return preferred_main
    end

    local root = find_project_root()
    if not root or root == "" then
        return nil
    end

    local input = trim(vim.fn.input("Main class (e.g. com.example.Main): "))
    if input ~= "" then
        return input
    end

    return nil
end

local function resolve_custom_launch_mainclass(root)
    local input = trim(vim.fn.input("Custom class name: "))
    if input ~= "" then
        save_stored_mainclass(root, input)
        return input
    end

    return nil
end

local function build_java_launch_configs(root)
    local configs = {}

    table.insert(configs, mark_owned_java_launch({
        type = "java",
        request = "launch",
        name = "Launch Java main class",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        mainClass = function()
            local preferred_main = find_preferred_mainclass()
            if preferred_main and preferred_main ~= "" then
                return preferred_main
            end

            return resolve_launch_mainclass()
        end,
        projectName = "",
    }))

    table.insert(configs, mark_owned_java_launch({
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

            return resolve_launch_mainclass()
        end,
        projectName = "",
    }))

    table.insert(configs, mark_owned_java_launch({
        type = "java",
        request = "launch",
        name = "Custom",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        mainClass = function()
            return resolve_custom_launch_mainclass(root)
        end,
        projectName = "",
    }))

    for _, class_name in ipairs(read_stored_mainclasses(root)) do
        table.insert(configs, mark_owned_java_launch({
            type = "java",
            request = "launch",
            name = "Custom: " .. class_name,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            mainClass = class_name,
            projectName = "",
        }))
    end

    table.insert(configs, mark_owned_java_launch({
        type = "java",
        request = "attach",
        name = "Attach to remote JVM (:5005)",
        hostName = "127.0.0.1",
        port = function()
            local port = tonumber(vim.fn.input("JVM debug port: ", "5005"))
            return port or 5005
        end,
    }))

    return configs
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
    local root = find_project_root()
    if not root or root == "" then
        return
    end

    local existing = dap.configurations.java or {}
    local filtered = {}
    for _, config in ipairs(existing) do
        if not is_owned_java_launch(config) then
            table.insert(filtered, config)
        end
    end

    local configs = build_java_launch_configs(root)
    for _, config in ipairs(configs) do
        table.insert(filtered, config)
    end

    dap.configurations.java = filtered
end

return M
