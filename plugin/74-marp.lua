local lazy = require("utils.lazy")

lazy.on_filetype("markdown", function()
    vim.pack.add({ "https://github.com/nwiizo/marp.nvim" })
    require("marp").setup()
end)
