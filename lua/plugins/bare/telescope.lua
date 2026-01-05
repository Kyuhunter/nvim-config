---@module "telescope"
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "apdot/doodle",
    },

    opts = {
        extensions = {
            doodle = {},
        },
    },

    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("doodle")
    end,

    keys = {
        {
            "<leader>pf",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "Telescope find files",
        },
        {
            "<leader>pg",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Telescope live grep",
        },
        {
            "<leader>pb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Telescope list buffers",
        },
        {
            "<leader>pd",
            function()
                require("telescope.builtin").diagnostics()
            end,
            desc = "Telescope list diagnostics",
        },
        {
            "<leader>dfn",
            function()
                require("telescope").extensions.doodle.find_notes()
            end,
            desc = "Doodle Find Notes",
        },
        {
            "<leader>dff",
            function()
                require("telescope").extensions.doodle.find_files()
            end,
            desc = "Doodle Find Files",
        },
        {
            "<leader>dft",
            function()
                require("telescope").extensions.doodle.find_templates()
            end,
            desc = "Doodle Find Templates",
        },
    },
}

