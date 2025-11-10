return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            styles = {bold = true, italic = true, transparency = true},
            highlight_groups = {
                -- HLs in italics
                Comment = {italic = true},
                Keyword = {italic = true},
                ["@keyword.return"] = {italic = true},
                -- Silence notify warning
                NotifyBackground = {bg = "base"},
                -- Things that should not be italic..
                ["@variable"] = {italic = false},
                ["@property"] = {italic = false},
                ["lsp.typemod.string.defaultLibrary.lua"] = {italic = false},
                ["@spell"] = {italic = false},
            }

        })
        vim.cmd("colorscheme rose-pine")
    end
}

