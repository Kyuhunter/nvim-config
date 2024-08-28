vim.filetype.add({
    extension = {
        html5 = function()
            vim.bo.filetype = 'php'
            vim.opt_local.textwidth = 0
            vim.opt_local.wrapmargin = 0
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
        end,
    }
})