vim.pack.add({ "https://github.com/kevalin/mermaid.nvim" })

require("mermaid").setup({
    format = {
        shift_width = 4,
    },
    lint = {
        enabled = true,
        command = "mmdc",
    },
    preview = {
        renderer = "mermaid.js",
        theme = "default",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("mermaid-keymaps", { clear = true }),
    pattern = "mermaid",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "<leader>mp", "<cmd>MermaidPreview<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Preview" }))
        vim.keymap.set("n", "<leader>mf", "<cmd>MermaidFormat<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Format" }))
        vim.keymap.set("n", "<leader>mr", "<cmd>MermaidRender<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Render" }))
        vim.keymap.set("n", "<leader>mc", "<cmd>MermaidCopyURL<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Copy URL" }))
        vim.keymap.set("n", "<leader>md",
            "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Diagnostics" }))
        vim.keymap.set("n", "<leader>mx", "<cmd>MermaidPreviewStop<CR>",
            vim.tbl_extend("force", opts, { desc = "Mermaid Stop Preview" }))
    end,
})
