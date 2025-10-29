return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate'
    },  {"Bilal2453/luvit-meta", lazy = true}, -- optional `vim.uv` typings
    {
        "folke/todo-comments.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        opts = {},
        event = "VeryLazy"
    },  {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {watch_for_changes = true},
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        init = function()
            vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>",
                           {desc = "Open Oil in current buffer"})
            vim.keymap.set("n", "-", "<cmd>Oil<CR>",
                           {desc = "Open Oil in current Buffer"})

        end
    }, {
        'sbdchd/neoformat',
        cmd = {"Neoformat"},
        keys = {{"<leader>F", ":Neoformat<CR>"}},
        init = function()
            vim.g.neoformat_try_node_exe = 1

            local fts = {
                "javascript", "javascriptreact", "typescript",
                "typescriptreact", "json", "jsonc", "yaml", "markdown", "html",
                "htmlangular", "angularhtml", "css", "scss", "less", "graphql"
            }
            for _, ft in ipairs(fts) do
                vim.g["neoformat_" .. ft .. "_prettierd"] = {
                    exe = "prettierd",
                    args = {"%:p"},
                    stdin = 1
                }
                vim.g["neoformat_enabled_" .. ft] = {"prettierd"}
            end
        end,
        config = function()
            -- Format on save (only for the filetypes above)
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = {
                    "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.jsonc",
                    "*.yml", "*.yaml", "*.md", "*.html", "*.css", "*.scss",
                    "*.less", "*.graphql", "*.lua"
                },
                callback = function()
                    -- silent! avoids noise if a filetype isn’t configured
                    vim.cmd("silent! Neoformat")
                end
            })
        end
    }, {
        "olrtg/nvim-emmet",
        event = "InsertEnter",
        config = function()
            vim.keymap.set({"n", "v"}, '<leader>xe',
                           require('nvim-emmet').wrap_with_abbreviation)
        end
    }, {
        "mason-org/mason-lspconfig.nvim",
        opts = {automatic_enable = {exclude = {"emmet_language_server"}}},
        dependencies = {
            {"mason-org/mason.nvim", opts = {}}, "neovim/nvim-lspconfig"
        }
    }, {"folke/lazydev.nvim", ft = "lua"}, {
        'saghen/blink.nvim',
        build = 'cargo build --release', -- for delimiters
        keys = {
            -- chartoggle
            {
                '<C-;>',
                function()
                    require('blink.chartoggle').toggle_char_eol(';')
                end,
                mode = {'n', 'v'},
                desc = 'Toggle ; at eol'
            }, {
                ',',
                function()
                    require('blink.chartoggle').toggle_char_eol(',')
                end,
                mode = {'n', 'v'},
                desc = 'Toggle , at eol'
            }
        },
        -- all modules handle lazy loading internally
        lazy = false,
        opts = {chartoggle = {enabled = true}}
    }, {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {'rafamadriz/friendly-snippets', "onsails/lspkind.nvim"},

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {preset = 'super-tab'},

            appearance = {nerd_font_variant = 'mono'},

            completion = {
                documentation = {auto_show = true},
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    if vim.tbl_contains({"Path"},
                                                        ctx.source_name) then
                                        local mini_icon, _ = require(
                                                                 "mini.icons").get_icon(
                                                                 ctx.item.data
                                                                     .type,
                                                                 ctx.label)
                                        if mini_icon then
                                            return mini_icon .. ctx.icon_gap
                                        end
                                    end

                                    local icon =
                                        require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol"
                                        })
                                    return icon .. ctx.icon_gap
                                end,

                                highlight = function(ctx)
                                    if vim.tbl_contains({"Path"},
                                                        ctx.source_name) then
                                        local mini_icon, mini_hl = require(
                                                                       "mini.icons").get_icon(
                                                                       ctx.item
                                                                           .data
                                                                           .type,
                                                                       ctx.label)
                                        if mini_icon then
                                            return mini_hl
                                        end
                                    end
                                    return ctx.kind_hl
                                end
                            },
                            kind = {
                                highlight = function(ctx)
                                    if vim.tbl_contains({"Path"},
                                                        ctx.source_name) then
                                        local mini_icon, mini_hl = require(
                                                                       "mini.icons").get_icon(
                                                                       ctx.item
                                                                           .data
                                                                           .type,
                                                                       ctx.label)
                                        if mini_icon then
                                            return mini_hl
                                        end
                                    end
                                    return ctx.kind_hl
                                end
                            }
                        }
                    }
                }
            },
            sources = {
                default = {'lazydev', 'lsp', 'path', 'snippets', 'buffer'},
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100
                    }
                }
            },
            fuzzy = {implementation = "prefer_rust_with_warning"}
        },
        opts_extend = {"sources.default"}
    }
}
