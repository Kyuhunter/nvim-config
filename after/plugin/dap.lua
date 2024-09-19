local dap = require('dap')

local cpptools_path = vim.fn.stdpath('data')..'/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = cpptools_path,
}


vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))()<CR>')
vim.keymap.set('n', '<leader>lp', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))()<CR>')
vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.open()<CR>')

local rr_dap = require('nvim-dap-rr')
rr_dap.setup({
    mappings = {
        continue = '<F5>',
        step_over = '<F10>',
        step_into = '<F11>',
        step_out = '<F12>',
        reverse_continue = '<F17>',
        reverse_step_over = '<F22>',
        reverse_step_into = '<F23>',
        reverse_step_out = '<F24>',
        step_over_i = '<F34>',
        step_into_i = '<F35>',
        step_out_i = '<F36>',
        reverse_step_over_i = '<F46>',
        reverse_step_into_i = '<F47>',
        reverse_step_out_i = '<F48>',
    }
})
dap.adapters["lldb"] = function(adapter_callback, config, parent)
    adapter_callback {
        id = 'lldb',
        type = 'executable',
        command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- must be absolute path
    }
end
dap.configurations.rust = { rr_dap.get_rust_config(
{
    type = 'lldb',
    name = 'Lauch',
    request = 'launch',
    -- program = function()
        -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    -- end,
    cwd = '${workspaceFolder}',
    -- stopOnEntry = false,
    -- args = {},
    -- initCommands = function()
        -- Find out where to look for the pretty printer Python module
        -- local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
--
        -- local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
        -- local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

        -- local commands = {}
        -- local file = io.open(commands_file, 'r')
        -- if file then
            -- for line in file:lines() do
                -- table.insert(commands, line)
            -- end
            -- file:close()
        -- end
        -- table.insert(commands, 1, script_import)

        -- return commands
    -- end,
}) }
dap.configurations.cpp = { rr_dap.get_config() }