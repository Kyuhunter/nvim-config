vim.pack.add({
    "https://www.github.com/folke/lazydev.nvim",
    "https://www.github.com/neovim/nvim-lspconfig",
    "https://www.github.com/mason-org/mason.nvim",
    "https://www.github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://www.github.com/mason-org/mason-lspconfig.nvim",
})

require("lazydev").setup({})
require("mason").setup({}) -- stays eager: puts $MASON/bin on PATH for LSP/jdtls

-- Registry lookups are slow on cold start; run them after startup instead.
-- vim.lsp.enable() after VimEnter still attaches to already open buffers.
pcall(vim.api.nvim_del_augroup_by_name, "mti_start") -- we trigger run_on_start ourselves
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(function()
            require("mason-lspconfig").setup({
                automatic_enable = { exclude = { "java", "java_language_server", "jdtls" } },
            })
            require("mason-tool-installer").setup({
                -- LuaFormatter off
              ensure_installed = {
                'biome',
                'prettierd',
                'lua_ls',
                'jdtls',
                'java-debug-adapter',
                'java-test',
                'checkstyle',
                'angularls',
                'ts_ls',
                'emmet_language_server',
                'eslint',
                'clangd',
                'gopls',
                'delve',
                'mmdc',
                'latexindent',
                'luaformatter',
                'xmlformatter',
                'debugpy',
              }
              -- LuaFormatter on
            })
            require("mason-tool-installer").run_on_start()
        end)
    end,
})

vim.lsp.enable({
    "lua_ls",
    "angularls",
    "ts_ls",
    "emmet_language_server",
    "eslint",
    "clangd",
    "gopls",
})

require("which-key").add({
    { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "x" }, desc = "Code action" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename symbol" },
    { "<leader>cd", vim.lsp.buf.definition, desc = "Go to definition" },
    { "<leader>cD", vim.lsp.buf.declaration, desc = "Go to declaration" },
    { "<leader>cR", vim.lsp.buf.references, desc = "References" },
    { "<leader>ce", vim.diagnostic.open_float, desc = "Line diagnostics" },
    { "<leader>cL", vim.lsp.codelens.run, desc = "Run code lens" },
    {
        "<leader>ci",
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end,
        desc = "Toggle inlay hints",
    },
})
