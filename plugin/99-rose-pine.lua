vim.pack.add({
  'https://www.github.com/rose-pine/neovim'
})

local rosepine = require('rose-pine')

rosepine.setup({
  styles = {bold = true, italic = true, transparency = true},
  highlight_groups = {
    Comment = {italic = true},
    Keyword = {italic = true},
    ["@keyword.return"] = {italic = true},
    -- Silence notify warning
    NotifyBackground = {bg = "base"},
    -- Things that should not be italic..
    ["@variable"] = {italic = false},
    ["@property"] = {italic = false},
    ["lsp.typemod.string.defaultLibrary.lua"] = {italic = false},
    ["@spell"] = {italic = false}
  }
})

vim.cmd('colorscheme rose-pine')
