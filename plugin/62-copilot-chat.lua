local lazy = require("utils.lazy")

lazy.later(function()
    local loaded = false

    local function ensure_loaded()
        if loaded then
            return true
        end

        vim.pack.add({
            {
                src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
                version = "copilot/fix-models-list-error",
            },
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
            model = "auto",
        })
        loaded = true
        return true
    end

    local function toggle_chat()
        if ensure_loaded() then
            vim.cmd("CopilotChatToggle")
        end
    end

    local function select_model()
        if ensure_loaded() then
            vim.cmd("CopilotChatModels")
        end
    end

    vim.keymap.set({ "n", "v" }, "<leader>ac", toggle_chat, {
        desc = "Toggle Copilot Chat",
    })

    vim.keymap.set("n", "<leader>am", select_model, {
        desc = "Select Copilot Chat model",
    })

    vim.api.nvim_create_user_command("CopilotChatLoad", function()
        ensure_loaded()
    end, {
        desc = "Load CopilotChat plugin",
    })
end)
