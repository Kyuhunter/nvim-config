return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
        ensure_installed = { "angular", "typescript", "javascript", "java" },
        auto_install = true,
    }
}
