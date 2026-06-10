vim.pack.add({ "https://github.com/arborist-ts/arborist.nvim" })

local arborist = require("arborist")

arborist.setup()
if vim.treesitter.language.add("mermaid") ~= true then
    arborist.install("mermaid")
end
