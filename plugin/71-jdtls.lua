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

-- Priorisierte Marker: erst Build-Marker (gewinnt das *nächste* Sub-Projekt),
-- dann erst `.git` als Fallback. Sonst „schluckt" ein großes Git-Repo
-- alle Sub-Projekte, weil der Repo-Root als root_dir gewählt wird.
local root_markers = {
    { "mvnw", "gradlew" },
    { "pom.xml", "build.gradle", "build.gradle.kts",
      "settings.gradle", "settings.gradle.kts" },
    { ".git" },
}

--- Findet das Projekt-Root für JDTLS.
--- Bevorzugt das *tiefste* Verzeichnis oberhalb der Datei, das ein
--- `src/main/java` oder `src/test/java` enthält — so gewinnen Sub-Projekte
--- immer gegen einen Aggregator-`pom.xml` oder ein `.git` am Repo-Root.
--- Fallback: priorisierte `root_markers`.
local function find_project_root(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then path = vim.uv.cwd() end

    -- 1. Tiefstes Verzeichnis mit src/main/java oder src/test/java.
    --    `vim.fs.parents` liefert von tief nach flach → erstes Match gewinnt.
    for dir in vim.fs.parents(path) do
        for _, sub in ipairs({ "src/main/java", "src/test/java" }) do
            local stat = vim.uv.fs_stat(dir .. "/" .. sub)
            if stat and stat.type == "directory" then
                return dir
            end
        end
    end

    -- 2. Fallback: priorisierte Marker.
    for _, group in ipairs(root_markers) do
        local r = vim.fs.root(bufnr, group)
        if r then return r end
    end
    return nil
end

local function start_jdtls()
    local jdtls = require("jdtls")
    local root_dir = find_project_root(0)
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
                -- Nur das aktuelle Sub-Projekt importieren, nicht
                -- Geschwister-Module eines übergeordneten Aggregator-POMs.
                -- Default-Exclusions + alles, was *nicht* das aktuelle root_dir ist,
                -- wird ohnehin nicht aktiv geladen — diese Liste verhindert,
                -- dass JDTLS in tief verschachtelten Repos beim Crawl andere
                -- Build-Verzeichnisse für eigenständige Projekte hält.
                import = {
                    exclusions = {
                        "**/node_modules/**",
                        "**/.metadata/**",
                        "**/archetype-resources/**",
                        "**/META-INF/maven/**",
                        "**/target/**",
                        "**/build/**",
                    },
                },
            },
        },
        init_options = {
            bundles = get_bundles(),
        },
        on_attach = function(client, bufnr)
            -- jdtls registriert `inlayHintProvider` dynamisch *nach* dem Attach,
            -- daher hier bedingungslos aktivieren. Neovim rendert nur, wenn der
            -- Server tatsächlich Hints liefert.
            if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

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

            require("which-key").add({
                buffer = bufnr,
                { "<leader>lo", function() require("jdtls").organize_imports() end, desc = "Organize imports" },
                { "<leader>lv", function() require("jdtls").extract_variable() end, desc = "Extract variable" },
                { "<leader>lc", function() require("jdtls").extract_constant() end, desc = "Extract constant" },
                {
                    "<leader>lm",
                    function() require("jdtls").extract_method(true) end,
                    mode = "x",
                    desc = "Extract method",
                },
                { "<leader>ll", "<cmd>JdtShowLogs<cr>", desc = "Show JDTLS logs" },
            })

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
