---@type vim.lsp.Config
return {
    cmd = {'emmet-language-server', '--stdio'},
    filetypes = {
        'css', 'eruby', 'html', 'htmlangular', 'htmldjango',
        'javascriptreact', 'less', 'pug', 'sass', 'scss', 'svelte', 'templ',
        'typescriptreact', 'vue'
     },
    root_markers = {'.git'},
    init_options = {preferences = {["profile.allowCompactBoolean"] = true}}
}
