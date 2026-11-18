vim.pack.add({ "https://github.com/arborist-ts/arborist.nvim" })

-- Own setup with options; the flag stops arborist's plugin/arborist.lua from re-running setup() without them.
-- Plugin/UI filetypes without parser repos; arborist would guess GitHub URLs, which triggers a keychain prompt.
vim.g.arborist_loaded = true
local arborist = require("arborist")
arborist.setup({
    prefer_wasm = false, -- WASM build needs a running Docker; native .so works without it
    ignore = {
        "trouble", "cmd", "msg", "pager", "dialog", "nvim-pack", "wk", "conform-info", "gitsigns-blame", "mason_backdrop",
        "oil_preview", "oil_progress", "vimtex-toc", "guihua", "guihua_rust", "PlenaryTestPopup",
        "dap-repl", "dap-float", "dapui_breakpoints", "dapui_console", "dapui_hover", "dapui_scopes", "dapui_stacks", "dapui_watches",
        "snacks_input", "snacks_layout_box", "snacks_notif_history", "snacks_picker_input", "snacks_picker_list",
        "snacks_picker_preview", "snacks_win_backdrop", "snacks_win_help",
        "minifiles", "minifiles-help", "mininotify", "mininotify-history", "minipick", "ministarter", "minideps-confirm", "minitest", "minimap",
    },
})
-- arborist prepends its own queries to runtimepath; put our fixed queries before them.
vim.opt.runtimepath:prepend(vim.fn.stdpath("config") .. "/overrides")
if vim.treesitter.language.add("mermaid") ~= true then
    arborist.install("mermaid")
end
