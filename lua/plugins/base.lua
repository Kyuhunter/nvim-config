return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd([[colorscheme rose-pine]]) end
    }, {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate'
    }, {
        'lewis6991/gitsigns.nvim',
        event = "VeryLazy",
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({']c', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end)

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end)

                -- Actions
                map('n', '<leader>hs', gitsigns.stage_hunk)
                map('n', '<leader>hr', gitsigns.reset_hunk)

                map('v', '<leader>hs', function()
                    gitsigns.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})
                end)

                map('v', '<leader>hr', function()
                    gitsigns.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})
                end)

                map('n', '<leader>hS', gitsigns.stage_buffer)
                map('n', '<leader>hR', gitsigns.reset_buffer)
                map('n', '<leader>hp', gitsigns.preview_hunk)
                map('n', '<leader>hi', gitsigns.preview_hunk_inline)

                map('n', '<leader>hb',
                    function() gitsigns.blame_line({full = true}) end)

                map('n', '<leader>hd', gitsigns.diffthis)

                map('n', '<leader>hD', function()
                    gitsigns.diffthis('~')
                end)

                map('n', '<leader>hQ', function()
                    gitsigns.setqflist('all')
                end)
                map('n', '<leader>hq', gitsigns.setqflist)

                -- Toggles
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                map('n', '<leader>tw', gitsigns.toggle_word_diff)

                -- Text object
                map({'o', 'x'}, 'ih', gitsigns.select_hunk)
            end
        }
    }, {
        'nvim-lualine/lualine.nvim',
        event = "BufEnter",
        dependencies = {'nvim-tree/nvim-web-devicons'},
        opts = {
            opts = {
                function(_, opts)
                    local trouble = require("trouble")
                    local symbols = trouble.statusline({
                        mode = "lsp_document_symbols",
                        groups = {},
                        title = false,
                        filter = {range = true},
                        format = "{kind_icon}{symbol.name:Normal}",
                        -- The following line is needed to fix the background color
                        -- Set it to the lualine section you want to use
                        hl_group = "lualine_c_normal"
                    })
                    table.insert(opts.sections.lualine_c,
                                 {symbols.get, cond = symbols.has})
                end
            }
        }
    }, {"Bilal2453/luvit-meta", lazy = true}, -- optional `vim.uv` typings
    {
        "wintermute-cell/gitignore.nvim",
        cmd = "Gitignore",
        config = function() require('gitignore') end
    }, {
        "folke/todo-comments.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        opts = {},
        event = "VeryLazy"
    }, {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {columns = {"icon"}},
        -- Optional dependencies
        lazy = false,
        keys = {{"<leader>pv", ":Oil<CR>"}}
    }, {
        'nvim-mini/mini.nvim',
        version = '*',
        config = function()
            require('mini.pick').setup({})
            require('mini.snippets').setup({})
            require('mini.icons').setup({})
        end,
        keys = {
            {"<leader>pf", ":Pick files<CR>"},
            {"<leader>pg", ":Pick grep_live<CR>"}
        }
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
                    "*.less", "*.graphql"
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
    }, {
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
        dependencies = {'rafamadriz/friendly-snippets'},

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'de}fault' (recommended) for mappings similar to built-in completions (C-y to accept)
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
            keymap = {preset = 'enter'},

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {documentation = {auto_show = false}},

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {default = {'lsp', 'path', 'snippets', 'buffer'}},

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {implementation = "prefer_rust_with_warning"}
        },
        opts_extend = {"sources.default"}
    }, {"tpope/vim-fugitive"}
}
