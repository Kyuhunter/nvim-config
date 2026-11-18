vim.pack.add({
    "https://www.github.com/mfussenegger/nvim-dap",
    "https://www.github.com/rcarriga/nvim-dap-ui",
    "https://www.github.com/theHamsta/nvim-dap-virtual-text",
    "https://www.github.com/folke/lazydev.nvim",
    "https://www.github.com/Bilal2453/luvit-meta",
    "https://www.github.com/nvim-neotest/nvim-nio",
})

require("lazydev").setup({
    library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { plugins = { "nvim-dap-ui" }, types = true },
    },
})

-- dap/dap-ui/adapters load on first debug keymap, not at startup
local loaded = false
local function setup()
    if loaded then return end
    loaded = true
    require("config.dap.virtual-text")
    require("config.dap_ui")
    require("config.dap.clang")
    require("config.dap.debugpy")
    require("config.dap.js-debug-adapter")
    require("config.dap.jdtls")
    require("config.dap.go")
end

local function lazy(fn)
    return function()
        setup()
        if type(fn) == "string" then vim.cmd(fn) else fn() end
    end
end

local wk = require("which-key")
local function dap_continue()
    if vim.bo.filetype == "java" then
        local ok, jdtls_dap = pcall(require, "config.dap.jdtls")
        if ok then
            jdtls_dap.ensure_adapter()
            jdtls_dap.ensure_configs()
        end
    end

    require("dap").continue()
end

wk.add({
    {
        "<F1>",
        lazy(function()
            require("dap.ui.widgets").hover(nil, { border = "rounded" })
        end),
        desc = "DAP Hover",
    }, { "<F4>", lazy("DapTerminate"),                desc = "DAP Terminate" },
    { "<F5>",      lazy(dap_continue),                               desc = "DAP continue" },
    { "<F6>",      lazy(function() require("dap").run_to_cursor() end), desc = "Run to Cursor" },
    { "<F10>",     lazy("DapStepOver"),                   desc = "Step Over" },
    { "<F11>",     lazy("DapStepInto"),                   desc = "Step Into" },
    { "<F12>",     lazy("DapStepOut"),                    desc = "Step Out" },
    { "<leader>b", lazy("DapToggleBreakpoint"),           desc = "Toggle Breakpoint" },
    { "<F24>",     lazy(function() require("dapui").toggle() end), desc = "Toggle DAP UI" },
    { "<leader>dc", lazy(dap_continue), desc = "Continue / start" },
    { "<leader>dC", lazy(function() require("dap").run_to_cursor() end), desc = "Run to cursor" },
    { "<leader>dl", lazy("DapRerun"), desc = "Rerun last" },
    { "<leader>dp", lazy("DapPause"), desc = "Pause" },
    { "<leader>dt", lazy("DapTerminate"), desc = "Terminate" },
    { "<leader>dr", lazy("DapToggleRepl"), desc = "Toggle REPL" },
    { "<leader>du", lazy(function() require("dapui").toggle() end), desc = "Toggle UI" },
    { "<leader>de", lazy(function() require("dapui").eval() end), mode = { "n", "x" }, desc = "Evaluate" },
    { "<leader>dv", lazy("DapVirtualTextToggle"), desc = "Toggle virtual text" },
    {
        "<leader>dB",
        lazy(function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end),
        desc = "Conditional breakpoint",
    },
    { "<leader>dx", lazy("DapClearBreakpoints"), desc = "Clear breakpoints" },
})

