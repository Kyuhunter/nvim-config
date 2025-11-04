local ftMap = {vim = 'indent', python = {'indent'}, git = ''}

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix ..
                             (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    -- version = '^1.5.0', -- optional: pin to specific version
    init = function()
        -- Set basic fold options early
        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    opts = {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
            default = {'imports', 'comment'},
            json = {'arrays'}, -- changed from 'array' to 'arrays'
            c = {'comment', 'region'}
        },
        close_fold_current_line_for_ft = {default = true, c = false},
        preview = {
            win_config = {
                border = {'', '─', '', '', '', '─', '', ''},
                winhighlight = 'Normal:Folded',
                winblend = 0
            },
            mappings = {
                scrollU = '<C-u>',
                scrollD = '<C-d>',
                jumpTop = '[',
                jumpBot = ']'
            }
        },
        provider_selector = function(bufnr, filetype, buftype)
            return ftMap[filetype] or {'treesitter', 'indent'}
        end,
        fold_virt_text_handler = handler
    },
    keys = {
        { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open All Folds' },
        { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close All Folds' },
        { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open Folds Except Kinds' },
        { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'Close Folds With' },
        { 'K', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, desc = 'Peek fold or hover' }
    }
}
