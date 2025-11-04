return {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets', "onsails/lspkind.nvim",
            "nvim-mini/mini.nvim"
        },
        event = "InsertEnter",
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
            keymap = {preset = 'enter'},

            appearance = {nerd_font_variant = 'mono'},

            completion = {
                documentation = {auto_show = true},
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local kind_icon, _, _ =
                                        require('mini.icons').get('lsp',
                                                                  ctx.kind)
                                    return kind_icon
                                end,
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ =
                                        require('mini.icons').get('lsp',
                                                                  ctx.kind)
                                    return hl
                                end
                            },
                            kind = {
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ =
                                        require('mini.icons').get('lsp',
                                                                  ctx.kind)
                                    return hl
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
