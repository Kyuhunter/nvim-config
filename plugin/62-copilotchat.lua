local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/zbirenbaum/copilot.lua",
        "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
    })

    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })

    vim.ui.select = require("mini.pick").ui_select

    require("CopilotChat").setup({
        window = {
            layout = "vertical",
            width = 0.4,
        },
    })

    local wk = require("which-key")
    wk.add({
        icon = { icon = "", color = "blue" },
        { "<leader>a",  group = "AI / Copilot Chat" },
        { "<leader>aa", "<cmd>CopilotChatToggle<cr>",  desc = "Toggle Chat" },
        { "<leader>ao", "<cmd>CopilotChatOpen<cr>",    desc = "Open Chat" },
        { "<leader>ac", "<cmd>CopilotChatClose<cr>",   desc = "Close Chat" },
        { "<leader>ar", "<cmd>CopilotChatReset<cr>",   desc = "Reset Chat" },
        { "<leader>am", "<cmd>CopilotChatModels<cr>",  desc = "Select Model" },
        { "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Select Prompt" },
        {
            "<leader>ae",
            "<cmd>CopilotChatExplain<cr>",
            desc = "Explain",
            mode = { "n", "v" },
        },
        {
            "<leader>af",
            "<cmd>CopilotChatFix<cr>",
            desc = "Fix",
            mode = { "n", "v" },
        },
        {
            "<leader>at",
            "<cmd>CopilotChatTests<cr>",
            desc = "Generate Tests",
            mode = { "n", "v" },
        },
        {
            "<leader>aR",
            "<cmd>CopilotChatReview<cr>",
            desc = "Review",
            mode = { "n", "v" },
        },
    })
end)
