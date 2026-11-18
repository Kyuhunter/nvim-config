vim.pack.add({ "https://github.com/lukas-reineke/virt-column.nvim" })

-- highlight entries map to columns in ascending order: 80, 100, 121
require("virt-column").setup({
    virtcolumn = "80,100,121",
    highlight = { "NonText", "NonText", "DiagnosticError" },
})
