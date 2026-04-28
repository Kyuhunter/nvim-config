vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

local Oil = require("oil")

Oil.setup({
    watch_for_changes = true,
    win_options = { winbar = "%!v:lua.get_oil_winbar()" },
})

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>",
               { desc = "Open Oil in current buffer" })
vim.keymap
    .set("n", "-", "<cmd>Oil<CR>", { desc = "Open Oil in current buffer" })
