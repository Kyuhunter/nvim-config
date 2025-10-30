local status, jdtls = pcall(require, "jdtls")
if not status then return end

local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local os_config = "linux"
if vim.fn.has "mac" == 1 then os_config = "mac" end

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn
                                       .glob(
                                       mason_path ..
                                           "packages/java-test/extension/server/*.jar"),
                                   "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path ..
                                                   "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
                                   "\n"))

---@type vim.lsp.Config
local config = {
    name = "jdtls",

    -- `cmd` defines the executable to launch eclipse.jdt.ls.
    -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
    --
    -- As alternative you could also avoid the `jdtls` wrapper and launch
    -- eclipse.jdt.ls via the `java` executable
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        home .. "/.sdkman/candidates/java/current/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true", "-Dlog.level=ALL", "-Xms1g",
        "--add-modules=ALL-SYSTEM", "--add-opens",
        "java.base/java.util=ALL-UNNAMED", "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. home ..
            "/.local/share/nvim/mason/packages/jdtls/lombok.jar", "-jar",
        vim.fn.glob(home ..
                        "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. os_config,
        "-data", workspace_dir
    },
    filetypes = {'java'},

    -- `root_dir` must point to the root of your project.
    -- See `:help vim.fs.root`
    root_dir = vim.fs.root(0, {'gradlew', '.git', 'mvnw'}),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            eclipse = {downloadSources = true},
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = home .. "/.sdkman/candidates/java/21.0.8-tem"
                    }
                }
            },
            referencesCodeLens = {enabled = true},
            references = {includeDecompiledSources = true},
            inlayHints = {
                parameterNames = {
                    enabled = "all" -- literals, all, none
                }
            },
            format = {enabled = false}
        },
        signatureHelp = {enabled = true}
    },
    on_attach = function(client, bufnr)
        local _, _ = pcall(vim.lsp.codelens.refresh)
        require("jdtls").setup_dap({hotcodereplace = "auto"})
        local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
        if status_ok then jdtls_dap.setup_dap_main_class_configs() end
    end,

    -- This sets the `initializationOptions` sent to the language server
    -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
    -- you'll need to set the `bundles`
    --
    -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
    init_options = {bundles = bundles}

}

require('jdtls').start_or_attach(config)

