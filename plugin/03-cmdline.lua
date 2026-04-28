local lazy = require("utils.lazy")

lazy.later(function()
    vim.o.cmdheight = 0
    vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" })
    require("tiny-cmdline").setup()
end)
