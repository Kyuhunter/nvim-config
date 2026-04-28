vim.pack.add({
    'https://github.com/folke/snacks.nvim'
})

local snacks = require("snacks")

snacks.setup({
    indent = { enabled = true, animate = { enabled = false } },
    statuscolumn = {
        enabled = true,
        left = { 'git', 'mark' },
        right = { 'fold', 'sign' }
    },
})
