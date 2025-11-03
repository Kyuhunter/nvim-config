return {
    {
        "olrtg/nvim-emmet",
        event = "InsertEnter",
        config = function()
            vim.keymap.set({"n", "v"}, '<leader>xe',
                           require('nvim-emmet').wrap_with_abbreviation)
        end
    }, {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            automatic_enable = {
                exclude = {"java", "java_language_server", "jdtls"}
            }
        },
        dependencies = {
            {"mason-org/mason.nvim", opts = {}}, "neovim/nvim-lspconfig"
        }
    }, {"folke/lazydev.nvim", ft = "lua"}
}
