local dap = require("dap")
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
        executable = {command = "js-debug-adapter", args = {"${port}"}},
        enrich_config = function(config, on_config)
            -- Under the hood, always use the main adapter
            config.type = pwa_adapter
            on_config(config)
        end
    }

    -- Dummy adapter, redirects to the main one
    dap.adapters[adapter] = dap.adapters[pwa_adapter]
end

local js_languages = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
}

for _, language in ipairs(js_languages) do
    dap.configurations[language] = dap.configurations[language] or {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
        },
    }
end
