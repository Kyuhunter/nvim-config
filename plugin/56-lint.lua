vim.pack.add({
    "https://www.github.com/mfussenegger/nvim-lint",
})

local checkstyle_config = os.getenv("HOME") .. "/.config/nvim/linter_configs/google_checks.xml"

local lint = require("lint")

local events = {
    "BufWritePost", "BufReadPost", "InsertLeave"
}
lint.linters_by_ft = {
    java = { "checkstyle" },
}
lint.linters.checkstyle.args = {
    "-f", "sarif", "-c", checkstyle_config
}

local M = {}

function M.debounce(ms, fn)
    local timer = assert(vim.uv.new_timer())
    return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
        end)
    end
end

vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = M.debounce(100, function()
        if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
            lint.try_lint()
        end
    end)
})
