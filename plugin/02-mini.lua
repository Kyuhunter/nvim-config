vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local wk = require("which-key")

require("mini.snippets").setup({})
require("mini.icons").setup({})
require("mini.pairs").setup({})
require("mini.basics").setup({})
require("mini.extra").setup({})
require("mini.surround").setup({})
require("mini.comment").setup({})
require("mini.completion").setup({
    window = { info = { border = "single" }, signature = { border = "single" } },
})
require("mini.pick").setup({})
wk.add({
    {
        "<leader>pf",
        function() require("mini.pick").builtin.files() end,
        desc = "Mini find files",
    }, {
        "<leader>pg",
        function() require("mini.pick").builtin.grep_live() end,
        desc = "Mini live grep",
    }, {
        "<leader>pb",
        function() require("mini.pick").builtin.buffers() end,
        desc = "Mini list buffers",
    },
    {
        "<leader>pd",
        function() require("mini.extra").pickers.diagnostic() end,
        desc = "Mini list diagnostics",
    }
})
require("mini.move").setup({})
require("mini.misc").setup({})
require("mini.cmdline").setup({})
