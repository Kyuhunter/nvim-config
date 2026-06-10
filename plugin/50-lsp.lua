vim.pack.add({
    "https://www.github.com/folke/lazydev.nvim",
    "https://www.github.com/neovim/nvim-lspconfig",
    "https://www.github.com/mason-org/mason.nvim",
    "https://www.github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://www.github.com/mason-org/mason-lspconfig.nvim",
})

require("lazydev").setup({})
require("mason").setup({})
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
  }
  -- LuaFormatter on
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
