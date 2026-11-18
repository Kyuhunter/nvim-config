local lazy = require("utils.lazy")

lazy.on_filetype("markdown", function()
    vim.pack.add({ "https://github.com/nwiizo/marp.nvim" })
    require("marp").setup()
end)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = vim.api.nvim_create_augroup("MarpKeymaps", { clear = true }),
    callback = function(ev)
        require("which-key").add({
            buffer = ev.buf,
            { "<leader>lw", "<cmd>MarpWatch<cr>", desc = "Marp watch" },
            { "<leader>lp", "<cmd>MarpPreview<cr>", desc = "Marp preview" },
            { "<leader>ls", "<cmd>MarpStop<cr>", desc = "Marp stop" },
            { "<leader>lS", "<cmd>MarpStopAll<cr>", desc = "Marp stop all" },
            { "<leader>li", "<cmd>MarpInfo<cr>", desc = "Marp info" },
            -- no <cr>: leaves the prompt open so format/theme can be completed
            { "<leader>le", ":MarpExport ", silent = false, desc = "Marp export" },
            { "<leader>lt", ":MarpTheme ", silent = false, desc = "Marp theme" },
        })
    end,
})
