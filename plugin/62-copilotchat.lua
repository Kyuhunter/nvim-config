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

    local curl = require("CopilotChat.utils.curl")
    local base_providers = require("CopilotChat.config.providers")

    require("CopilotChat").setup({
        model = "gpt-4o",
        window = {
            layout = "vertical",
            width = 0.4,
        },
        providers = {
            -- Override get_models to include models where model_picker_enabled=false
            -- (free_educational_quota plan disables the picker but all models are usable)
            copilot = vim.tbl_extend("force", base_providers.copilot, {
                get_models = function(headers)
                    local base_url = headers["x-copilot-base-url"] or "https://api.githubcopilot.com"
                    local request_headers = vim.tbl_extend("force", headers, { ["x-copilot-base-url"] = nil })

                    local response, err = curl.get(base_url .. "/models", {
                        json_response = true,
                        headers = request_headers,
                    })
                    if err then error(err) end

                    local models = vim
                        .iter(response.body.data)
                        :filter(function(m)
                            return m.capabilities and m.capabilities.type == "chat"
                        end)
                        :map(function(m)
                            local supported = m.supported_endpoints or {}
                            return {
                                id = m.id,
                                name = m.name,
                                tokenizer = m.capabilities.tokenizer,
                                max_input_tokens = m.capabilities.limits and m.capabilities.limits.max_prompt_tokens,
                                max_output_tokens = m.capabilities.limits and m.capabilities.limits.max_output_tokens,
                                streaming = m.capabilities.supports and m.capabilities.supports.streaming,
                                tools = m.capabilities.supports and m.capabilities.supports.tool_calls,
                                policy = true,
                                version = m.version or 0,
                                use_responses = vim.tbl_contains(supported, "/responses"),
                                base_url = base_url,
                            }
                        end)
                        :totable()

                    -- deduplicate by name, keep highest version
                    local by_name = {}
                    for _, m in ipairs(models) do
                        if not by_name[m.name] or (m.version or 0) > (by_name[m.name].version or 0) then
                            by_name[m.name] = m
                        end
                    end
                    return vim.tbl_values(by_name)
                end,
            }),
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
