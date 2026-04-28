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
        function()
            require("dap.ui.widgets").hover(nil, { border = "rounded" })
        end,
        desc = "DAP Hover",
    }, { "<F4>", "<cmd>DapTerminate<cr>",                desc = "DAP Terminate" },
    { "<F5>",      dap_continue,                               desc = "DAP continue" },
    { "<F6>",      "<cmd>DapRunToCursor<cr>",                desc = "Run to Cursor" },
    { "<F10>",     "<cmd>DapStepOver<cr>",                   desc = "Step Over" },
    { "<F11>",     "<cmd>DapStepInto<cr>",                   desc = "Step Into" },
    { "<F12>",     "<cmd>DapStepOut<cr>",                    desc = "Step Out" },
    { "<leader>b", "<cmd>DapToggleBreakpoint<cr>",           desc = "Toggle Breakpoint" },
    { "<F24>",     function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
})

require("config.dap.virtual-text")
require("config.dap_ui")
require("config.dap.clang")
require("config.dap.debugpy")
require("config.dap.js-debug-adapter")
require("config.dap.jdtls")
