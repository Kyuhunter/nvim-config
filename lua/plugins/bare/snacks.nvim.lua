return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = {enabled = true},
        image = {enabled = true},
        indent = {
            enabled = true,
            animate = {
                enabled = false
            }
        },
        notifier = {enabled = true, timeout = 3000},
        quickfile = {enabled = true},
        rename = {enabled = true},
        styles = {
            notification = {
                -- wo = { wrap = true } -- Wrap notifications
            }
        }
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
                if event.data.actions[1].type == "move" then
                    Snacks.rename.on_rename_file(event.data.actions[1].src_url,
                                                 event.data.actions[1].dest_url)
                end
            end
        })
    end
}
