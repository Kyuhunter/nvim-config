local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({
        "https://github.com/zbirenbaum/copilot.lua",
        "https://github.com/ray-x/copilot-agent.nvim",
    })

    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })

    require("copilot_agent").setup({
        lsp = { enabled = false },
    })

    local wk = require("which-key")
    wk.add({
        icon = { icon = "", color = "blue" },
        { "<leader>a", group = "AI / Copilot Agent" },
        { "<leader>aa", "<cmd>CopilotAgentChat<cr>", desc = "Chat" },
        { "<leader>ad", "<cmd>CopilotAgentDashboard<cr>", desc = "Dashboard" },
        { "<leader>am", "<cmd>CopilotAgentModel<cr>", desc = "Model" },
        { "<leader>an", "<cmd>CopilotAgentNewSession<cr>", desc = "New Session" },
        { "<leader>as", "<cmd>CopilotAgentSwitchSession<cr>", desc = "Switch Session" },
    })
end)
