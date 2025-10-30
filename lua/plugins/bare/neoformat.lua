return {
    'sbdchd/neoformat',
    cmd = {"Neoformat"},
    keys = {{"<leader>F", ":Neoformat<CR>"}},
    init = function()
        vim.g.neoformat_try_node_exe = 1

        local fts = {
            "javascript", "javascriptreact", "typescript", "typescriptreact",
            "json", "jsonc", "yaml", "markdown", "html", "htmlangular",
            "angularhtml", "css", "scss", "less", "graphql"
        }
        for _, ft in ipairs(fts) do
            vim.g["neoformat_" .. ft .. "_prettierd"] = {
                exe = "prettierd",
                args = {"%:p"},
                stdin = 1
            }
            vim.g["neoformat_enabled_" .. ft] = {"prettierd"}
        end
    end,
    config = function()
        -- Format on save (only for the filetypes above)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = {
                "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.jsonc", "*.yml",
                "*.yaml", "*.md", "*.html", "*.css", "*.scss", "*.less",
                "*.graphql", "*.lua"
            },
            callback = function()
                -- silent! avoids noise if a filetype isn’t configured
                vim.cmd("silent! Neoformat")
            end
        })
    end
}
