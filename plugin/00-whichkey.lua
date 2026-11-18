vim.pack.add({ "https://www.github.com/folke/which-key.nvim" })

local wk = require("which-key")
wk.setup({
    replace = {
        -- full default list; first pattern fixed: default `<Plug>%(?(.*)%)?` keeps the closing ")" (e.g. vimtex)
        desc = {
            { "<[pP]lug>%((.*)%)$", "%1" },
            { "<[pP]lug>", "" },
            { "^%+", "" },
            { "<[cC]md>", "" },
            { "<[cC][rR]>", "" },
            { "<[sS]ilent>", "" },
            { "^lua%s+", "" },
            { "^call%s+", "" },
            { "^:%s*", "" },
        },
    },
})

wk.add({
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>g", group = "Git" },
    { "<leader>i", group = "Info / Tools" },
    { "<leader>l", group = "Language" },
    { "<leader>p", group = "Pick" },
    { "<leader>t", group = "Test" },
    { "<leader>x", group = "Trouble" },
    { "<leader>ic", "<cmd>ConformInfo<cr>", desc = "Conform info" },
    { "<leader>il", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP health" },
    { "<leader>im", "<cmd>Mason<cr>", desc = "Mason" },
    { "<leader>ip", function() vim.pack.update() end, desc = "Update plugins" },
    { "<leader>it", "<cmd>MasonToolsUpdate<cr>", desc = "Update Mason tools" },
    { "<leader>ia", "<cmd>ArboristUpdate<cr>", desc = "Update Treesitter parsers" },
    {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
    },
    {
        "Q",
        "@q",
        desc = "Quick Macro",
    },
})
