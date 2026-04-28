local lazy = require("utils.lazy")

lazy.on_event('LspAttach', function()
    vim.pack.add({
        "https://www.github.com/folke/todo-comments.nvim",
        "https://github.com/nvim-lua/plenary.nvim"
    })
    require("todo-comments").setup()
end)
