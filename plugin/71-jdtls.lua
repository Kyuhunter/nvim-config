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
