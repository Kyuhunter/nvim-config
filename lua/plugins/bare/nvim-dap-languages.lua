return {
    {
        -- golang debugging
        'leoluz/nvim-dap-go',
        lazy = true,
        ft = "go",
        opts = {}
    }, {
        -- rust debugging
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false -- This plugin is already lazy
    }, {'mfussenegger/nvim-jdtls', dependencies = {'nvim-dap'}, ft = "java", opts ={}}
}
