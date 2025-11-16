return {
    {
        -- golang debugging
        "leoluz/nvim-dap-go",
        lazy = true,
        ft = "go",
        opts = {},
    },
    {
        -- rust debugging
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    { "mfussenegger/nvim-jdtls", dependencies = { "nvim-dap" }, ft = "java", opts = {} },
    {
        "Kyuhunter/gradle.nvim",
        cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {}, -- options, see default configuration
        keys = {
            { "<leader>G",  desc = "+Gradle",           mode = { "n", "v" } },
            { "<leader>Gg", "<cmd>Gradle<cr>",          desc = "Gradle Projects" },
            { "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Gradle Favorite Commands" },
        },
    },
}
