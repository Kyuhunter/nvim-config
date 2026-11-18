local lazy = require("utils.lazy")

lazy.on_filetype("markdown", function()
    vim.pack.add({ "https://github.com/OXY2DEV/markview.nvim" })
    require("markview").setup({})
end)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = vim.api.nvim_create_augroup("MarkviewKeymaps", { clear = true }),
    callback = function(ev)
        require("which-key").add({
            buffer = ev.buf,
            { "<leader>lm", "<cmd>Markview toggle<cr>", desc = "Markview toggle" },
            { "<leader>lM", "<cmd>Markview splitToggle<cr>", desc = "Markview split" },
        })
    end,
})
