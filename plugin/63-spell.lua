-- de.utf-8.spl is not bundled; nvim offers to download missing spell files on first use
vim.opt.spelllang = { "de", "en" }
vim.opt.spelloptions = { "camel", "noplainbuffer" }

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("spell-prose", { clear = true }),
    pattern = { "markdown", "text", "tex", "gitcommit" },
    callback = function() vim.opt_local.spell = true end,
})

local function lang(l)
    return function()
        vim.opt_local.spelllang = l
        vim.opt_local.spell = true
        vim.notify("spelllang=" .. l)
    end
end

-- built-in: ]s / [s next/prev error, zg add word, zw mark wrong, z= suggestions
require("which-key").add({
    { "<leader>s", group = "Spelling" },
    { "<leader>ss", function() vim.opt_local.spell = not vim.wo.spell end, desc = "Toggle spell check" },
    { "<leader>sd", lang("de"), desc = "Spell: Deutsch" },
    { "<leader>se", lang("en"), desc = "Spell: English" },
    { "<leader>sb", lang("de,en"), desc = "Spell: Deutsch + English" },
    { "<leader>sc", function() Snacks.picker.spelling() end, desc = "Spelling suggestions" },
    { "<leader>sf", "1z=", desc = "Fix with first suggestion" },
    { "<leader>sa", "zg", desc = "Add word to dictionary" },
})
