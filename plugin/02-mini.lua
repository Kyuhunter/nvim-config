vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
})

local wk = require("which-key")

local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
    snippets = { gen_loader.from_lang() },
})

-- Sessions sauber beenden, wenn der Insert-Mode verlassen wird.
-- Sonst bleiben die Tabstop-Marker („Rechtecke") sichtbar und lassen
-- sich nicht mit normalen Edit-Befehlen entfernen.
vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("mini-snippets-stop", { clear = true }),
    pattern = { "i:n", "s:n" },
    callback = function()
        local ok, mini_snippets = pcall(require, "mini.snippets")
        if ok and mini_snippets.session and mini_snippets.session.get() then
            pcall(mini_snippets.session.stop)
        end
    end,
})

-- Normal-Mode-Notbremse: <Esc><Esc> beendet eine hängengebliebene Session.
vim.keymap.set("n", "<Esc><Esc>", function()
    local ok, mini_snippets = pcall(require, "mini.snippets")
    if ok and mini_snippets.session and mini_snippets.session.get() then
        pcall(mini_snippets.session.stop)
    end
end, { desc = "Stop mini.snippets session" })

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
