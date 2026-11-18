local lazy = require("utils.lazy")

lazy.later(function()
    vim.pack.add({
        "https://www.github.com/tpope/vim-fugitive.git",
        "https://www.github.com/lewis6991/gitsigns.nvim",
    })

    require("which-key").add({
        { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
        { "<leader>gP", "<cmd>Git pull<cr>", desc = "Pull" },
        { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Fetch" },
        { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Log" },
        { "<leader>gb", "<cmd>Git blame<cr>", desc = "Blame file" },
        { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Diff split" },
        { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Stage file" },
        { "<leader>gB", "<cmd>Pick git_branches<cr>", desc = "Pick branches" },
        { "<leader>gL", "<cmd>Pick git_commits path='%'<cr>", desc = "Pick file commits" },
    })

    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local whichkey = require("which-key")

            whichkey.add({
                buffer = bufnr,
                icon = { icon = "", color = "orange" },
                { "<leader>h", group = "Gitsigns" },
                {
                    "]c",
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end,
                    desc = "Next Hunk",
                },
                {
                    "[c",
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end,
                    desc = "Previous Hunk",
                },
                {
                    "<leader>hs",
                    function() gitsigns.stage_hunk() end,
                    mode = { "n", "v" },
                    desc = "Stage Hunk",
                },
                {
                    "<leader>hr",
                    function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end,
                    desc = "Reset Selection",
                },
                {
                    "<leader>hS",
                    function() gitsigns.stage_buffer() end,
                    desc = "Stage Buffer",
                },
                {
                    "<leader>hR",
                    function() gitsigns.reset_buffer() end,
                    desc = "Reset Buffer",
                },
                {
                    "<leader>hp",
                    function() gitsigns.preview_hunk() end,
                    desc = "Preview Hunk",
                },
                {
                    "<leader>hi",
                    function() gitsigns.preview_hunk_inline() end,
                    desc = "Preview Hunk Inline",
                },
                {
                    "<leader>hb",
                    function() gitsigns.blame_line({ full = true }) end,
                    desc = "Blame Line",
                },
                {
                    "<leader>hd",
                    function() gitsigns.diffthis() end,
                    desc = "Diff Against Index",
                },
                {
                    "<leader>hD",
                    function() gitsigns.diffthis("~") end,
                    desc = "Diff Against Prev Commit",
                },
                {
                    "<leader>hQ",
                    function() gitsigns.setqflist("all") end,
                    desc = "All to QickFix",
                },
                {
                    "<leader>hq",
                    function() gitsigns.setqflist() end,
                    desc = "Buffer to QickFix",
                },
                -- Toggles
                {
                    "\\tb",
                    function() gitsigns.toggle_current_line_blame() end,
                    desc = "Toggle Current Line Blame",
                },
                {
                    "\\tw",
                    function() gitsigns.toggle_word_diff() end,
                    desc = "Toggle Word Diff",
                },
                -- Text object
                {
                    "ih",
                    function() gitsigns.select_hunk() end,
                    mode = { "o", "x" },
                    desc = "Select Current Hunk",
                },
            })
        end,
    })
end)
