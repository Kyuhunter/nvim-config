vim.pack.add({
    "https://github.com/ray-x/go.nvim",
    "https://github.com/ray-x/guihua.lua",
})

-- go.nvim is only needed in Go buffers: set it up on the first one
local go_loaded = false
local function setup_go(buf)
    if go_loaded then return end
    go_loaded = true
    require("go").setup({
        -- lsp_keymaps = false,
        textobjects = false,
    })
    -- setup() adds FileType-go autocmds; replay them for the buffer that triggered it
    vim.api.nvim_exec_autocmds("FileType", { group = "go.filetype", buffer = buf })
end

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").goimports()
    end,
    group = format_sync_grp,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    group = vim.api.nvim_create_augroup("GoKeymaps", { clear = true }),
    callback = function(ev)
        setup_go(ev.buf)
        require("which-key").add({
            buffer = ev.buf,
            { "<leader>lr", "<cmd>GoRun<cr>", desc = "Run" },
            { "<leader>lb", "<cmd>GoBuild<cr>", desc = "Build" },
            { "<leader>ll", "<cmd>GoLint<cr>", desc = "Lint" },
            { "<leader>lv", "<cmd>GoVet<cr>", desc = "Vet" },
            { "<leader>lm", "<cmd>GoModTidy<cr>", desc = "Mod tidy" },
            { "<leader>la", "<cmd>GoAlt<cr>", desc = "Alternate source/test" },
            { "<leader>lc", "<cmd>GoCoverage<cr>", desc = "Coverage" },
            { "<leader>lf", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
            { "<leader>le", "<cmd>GoIfErr<cr>", desc = "Add if err" },
            { "<leader>lt", "<cmd>GoAddTag<cr>", desc = "Add struct tags" },
            { "<leader>lT", "<cmd>GoRmTag<cr>", desc = "Remove struct tags" },
            { "<leader>tt", "<cmd>GoTestFile<cr>", desc = "Run file tests" },
            { "<leader>tr", "<cmd>GoTestFunc<cr>", desc = "Run nearest test" },
            { "<leader>tT", "<cmd>GoTestPkg<cr>", desc = "Run package tests" },
        })
    end,
})
