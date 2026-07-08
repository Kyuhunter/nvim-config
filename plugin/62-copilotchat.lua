local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({
        "https://github.com/zbirenbaum/copilot.lua",
    })

    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })

    -- Load copilot-agent only if the binary exists
    local agent_binary = vim.fn.fnamemodify(
        vim.fn.stdpath("data") .. "/site/pack/core/opt/copilot-agent.nvim/bin/copilot-agent",
        ":p"
    )
    if vim.fn.executable(agent_binary) == 1 or vim.fn.executable("copilot-agent") == 1 then
        vim.pack.add({ "https://github.com/ray-x/copilot-agent.nvim" })
        require("copilot_agent").setup({ lsp = { enabled = false } })

        local wk = require("which-key")
        wk.add({
            icon = { icon = "", color = "blue" },
            { "<leader>a", group = "AI / Copilot Agent" },
            { "<leader>aa", "<cmd>CopilotAgentChat<cr>", desc = "Chat" },
            { "<leader>ao", "<cmd>CopilotAgentCompose<cr>", desc = "Compose" },
            { "<leader>ad", "<cmd>CopilotAgentDashboard<cr>", desc = "Dashboard" },
            { "<leader>am", "<cmd>CopilotAgentModels<cr>", desc = "Switch Model" },
            {
                "<leader>ae",
                function()
                    vim.cmd.CopilotAgentCompose()
                end,
                desc = "Explain (Compose)",
                mode = { "n", "v" },
            },
        })
    else
        vim.notify(
            "copilot-agent binary not found. Run :CopilotAgentInstall in Neovim.",
            vim.log.levels.WARN
        )
    end
end)
