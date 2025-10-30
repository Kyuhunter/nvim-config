return {
    {
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
            keymap = {preset = 'enter'},

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
