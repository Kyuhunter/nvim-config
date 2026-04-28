vim.pack.add({ "https://www.github.com/folke/which-key.nvim" })

local wk = require("which-key")
wk.setup({})

wk.add({
    {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        { desc = "Buffer Local Keymaps (which-key)" },
    },
})
