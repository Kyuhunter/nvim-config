local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "run gofmt and goimports on save",
    pattern = "*.go",
    callback = function() require('go.format').goimports() end,
    group = vim.api.nvim_create_augroup("goimports", {})
})

autocmd("FileType", {
    desc = "Disable newline comments when inserting lines with o/O",
    callback = function() vim.opt_local.formatoptions:remove("o") end
})
