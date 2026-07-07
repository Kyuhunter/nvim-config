local lazy = require("utils.lazy")

lazy.later(function()
    local loaded = false

    local function ensure_loaded()
        if loaded then
            return true
        end

        vim.pack.add({
            "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
            "https://github.com/zbirenbaum/copilot.lua",
            "https://github.com/nvim-lua/plenary.nvim",
        })

        local ok_copilot, copilot = pcall(require, "copilot")
        if ok_copilot then
            copilot.setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end

        local ok_chat, copilot_chat = pcall(require, "CopilotChat")
        if not ok_chat then
            vim.notify("CopilotChat konnte nicht geladen werden", vim.log.levels.ERROR)
            return false
        end

        copilot_chat.setup({
            model = "gpt-4.1",
        })
        loaded = true
        return true
    end

    local function toggle_chat()
        if ensure_loaded() then
            vim.cmd("CopilotChatToggle")
        end
    end

    vim.keymap.set({ "n", "v" }, "<leader>ac", toggle_chat, {
        desc = "Toggle Copilot Chat",
    })

    vim.api.nvim_create_user_command("CopilotChatLoad", function()
        ensure_loaded()
    end, {
        desc = "Load CopilotChat plugin",
    })
end)
