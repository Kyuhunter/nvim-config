vim.cmd.packadd("nvim.undotree")

local wk = require("which-key")

wk.add({
    {
        '<leader>u',
        '<cmd>:Undotree<CR>',
        desc = "Open Undotree",
    }
})
