---@type vim.lsp.Config
return {
    before_init = function(params, config)
        local root_dir = config.root_dir
        if not root_dir then return end
        local package_json_path = root_dir .. '/package.json'
        if vim.fn.filereadable(package_json_path) == 0 then return end
        local package_content = vim.fn.readfile(package_json_path)
        local package_text = table.concat(package_content, '\n')
        local is_angular_project = package_text:find('@angular/core') ~= nil
        if not is_angular_project then return end
        local lang_service_path = root_dir ..
                                      '/node_modules/@angular/language-service/package.json'
        if vim.fn.filereadable(lang_service_path) == 0 then
            -- Install it automatically
            vim.notify('Installing @angular/language-service...',
                       vim.log.levels.INFO)
            -- Run npm install in the project directory
            local install_cmd = 'cd ' .. vim.fn.shellescape(root_dir) ..
                                    ' && npm install --save-dev @angular/language-service@latest typescript@^5.0'
            local result = vim.fn.system(install_cmd)
            if vim.v.shell_error ~= 0 then
                vim.notify('Failed to install @angular/language-service: ' ..
                               result, vim.log.levels.ERROR)
            else
                vim.notify('@angular/language-service installed successfully',
                           vim.log.levels.INFO)
                vim.defer_fn(function()
                    vim.fn.jobstart(vim.cmd(":LspRestart")) end, 3000)
            end
        end
    end
}
