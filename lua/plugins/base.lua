return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        opts = {

            -- A list of parser names, or "all" (the listed parsers MUST always be installed)
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "typescript", "rust", "python", "php", 'html' },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            highlight = {
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = true,
            },

            vim.treesitter.language.register('php', 'html5'),

            matchup = {
                enable = true,              -- mandatory, false will disable the whole extension
            },
        },
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    {
        'mbbill/undotree',
        init = function ()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end
    },
    {
        'lewis6991/gitsigns.nvim',
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
                map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('n', '<leader>hS', gitsigns.stage_buffer)
                map('n', '<leader>hu', gitsigns.undo_stage_hunk)
                map('n', '<leader>hR', gitsigns.reset_buffer)
                map('n', '<leader>hp', gitsigns.preview_hunk)
                map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                map('n', '<leader>hd', gitsigns.diffthis)
                map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                map('n', '<leader>td', gitsigns.toggle_deleted)

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    },
    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "Run git command" }
        }
    },
    {
        "olrtg/nvim-emmet",
        config = function()
            vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
        end,
    },
    {
        'captbaritone/better-indent-support-for-php-with-html'
    },
    {
        'andymass/vim-matchup',
        init = function ()
            vim.g.matchup_surround_enabled = 1
        end
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            toggler = {
                line = '<leader>cc',
                block = '<leader>bcc',
            }
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        event = "BufEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            opts = {
                function(_, opts)
                    local trouble = require("trouble")
                    local symbols = trouble.statusline({
                        mode = "lsp_document_symbols",
                        groups = {},
                        title = false,
                        filter = { range = true },
                        format = "{kind_icon}{symbol.name:Normal}",
                        -- The following line is needed to fix the background color
                        -- Set it to the lualine section you want to use
                        hl_group = "lualine_c_normal",
                    })
                    table.insert(opts.sections.lualine_c, {
                        symbols.get,
                        cond = symbols.has,
                    })
                end,
            }
        },
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    }, -- optional `vim.uv` typings
    {
        "wintermute-cell/gitignore.nvim",
        config = function()
            require('gitignore')
        end,
    },
    {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
},
{
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    }
}
}
