-- Custom Settings
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.fextensions")

-- Custom LSP-Settings
vim.lsp.enable('emmet')

-- Lazy.nvim
require("config.lazy")
