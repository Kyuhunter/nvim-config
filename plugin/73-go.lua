vim.pack.add({
    "https://github.com/ray-x/go.nvim",
    "https://github.com/ray-x/guihua.lua",
})

require("go").setup({
    -- lsp_keymaps = false,
    textobjects = false,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").goimports()
    end,
    group = format_sync_grp,
})
