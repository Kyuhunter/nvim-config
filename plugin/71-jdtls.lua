vim.pack.add({ "https://www.github.com/mfussenegger/nvim-jdtls" })

local function get_bundles()
    local bundles = {}
    vim.list_extend(
        bundles,
        vim.fn.globpath(
            vim.fn.expand("$MASON/share/java-debug-adapter"),
            "com.microsoft.java.debug.plugin*.jar",
            true,
            true
        )
    )
    vim.list_extend(
        bundles,
        vim.fn.globpath(
            vim.fn.expand("$MASON/share/java-test"),
            "*.jar",
            true,
            true
        )
    )
    return bundles
end

local function has_java_debug()
    return #vim.fn.globpath(
        vim.fn.expand("$MASON/share/java-debug-adapter"),
        "com.microsoft.java.debug.plugin*.jar",
        true,
        true
    ) > 0
end

local function has_java_test()
    return #vim.fn.globpath(
        vim.fn.expand("$MASON/share/java-test"),
        "*.jar",
        true,
        true
    ) > 0
end

local root_markers = {
    "mvnw",
    "gradlew",
    "pom.xml",
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    ".git",
}

local function start_jdtls()
    local jdtls = require("jdtls")
    local root_dir = vim.fs.root(0, root_markers)
    if not root_dir then return end

    -- Per-project workspace data directory to avoid cross-project cache corruption.
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

    jdtls.start_or_attach({
        cmd = {
            vim.fn.expand("$MASON/bin/jdtls"),
            "-data", workspace_dir,
        },
        root_dir = root_dir,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        settings = {
            java = {
                inlayHints = {
                    parameterNames = { enabled = "all" },
                },
            },
        },
        init_options = {
            bundles = get_bundles(),
        },
        on_attach = function(client, bufnr)
            if has_java_debug() and not client._jdtls_dap_setup then
                client._jdtls_dap_setup = true
                jdtls.setup_dap({
                    hotcodereplace = "auto",
                    config_overrides = {},
                })

                local dap = require("dap")
                if dap.providers and dap.providers.configs then
                    dap.providers.configs.jdtls = nil
                end
            end

            if has_java_test() then
                vim.keymap.set("n", "<leader>tt", function()
                    require("jdtls.dap").test_class()
                end, { buffer = bufnr, desc = "Run All Tests" })

                vim.keymap.set("n", "<leader>tr", function()
                    require("jdtls.dap").test_nearest_method()
                end, { buffer = bufnr, desc = "Run Nearest Test" })

                vim.keymap.set("n", "<leader>tT", function()
                    require("jdtls.dap").pick_test()
                end, { buffer = bufnr, desc = "Run Test" })
            end
        end,
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("jdtls-attach", { clear = true }),
    pattern = "java",
    callback = start_jdtls,
})
vim.pack.add({ "https://www.github.com/mfussenegger/nvim-jdtls" })

local M = {}

local function get_bundles()
  local bundles = {}

  vim.list_extend(
    bundles,
    vim.fn.globpath(
      vim.fn.expand("$MASON/share/java-debug-adapter"),
      "com.microsoft.java.debug.plugin*.jar",
      true,
      true
    )
  )

  vim.list_extend(
    bundles,
    vim.fn.globpath(
      vim.fn.expand("$MASON/share/java-test"),
      "*.jar",
      true,
      true
    )
  )

  return bundles
end

local function get_capabilities()
  return vim.lsp.protocol.make_client_capabilities()
end

function M.setup()
  local bundles = get_bundles()
  local has_java_debug = #vim.fn.globpath(
    vim.fn.expand("$MASON/share/java-debug-adapter"),
    "com.microsoft.java.debug.plugin*.jar",
    true,
    true
  ) > 0

  local has_java_test = #vim.fn.globpath(
    vim.fn.expand("$MASON/share/java-test"),
    "*.jar",
    true,
    true
  ) > 0

  vim.lsp.config("jdtls", {
    capabilities = get_capabilities(),

    root_markers = {
      ".git",
      "mvnw",
      "gradlew",
      "pom.xml",
      "settings.gradle",
      "settings.gradle.kts",
      "build.gradle",
      "build.gradle.kts",
    },

    settings = {
      java = {
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
      },
    },

    init_options = {
      bundles = bundles,
    },

    on_attach = function(client, bufnr)
      if has_java_debug and not client._jdtls_dap_setup then
        client._jdtls_dap_setup = true
        require("jdtls").setup_dap({
          hotcodereplace = "auto",
          config_overrides = {},
        })

        local dap = require("dap")
        if dap.providers and dap.providers.configs then
          dap.providers.configs.jdtls = nil
        end
      end

      if has_java_test then
        vim.keymap.set("n", "<leader>tt", function()
          require("jdtls.dap").test_class()
        end, { buffer = bufnr, desc = "Run All Tests" })

        vim.keymap.set("n", "<leader>tr", function()
          require("jdtls.dap").test_nearest_method()
        end, { buffer = bufnr, desc = "Run Nearest Test" })

        vim.keymap.set("n", "<leader>tT", function()
          require("jdtls.dap").pick_test()
        end, { buffer = bufnr, desc = "Run Test" })
      end
    end,
  })

  vim.lsp.enable("jdtls")
end

M.setup()

return M
