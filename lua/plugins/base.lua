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
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate"
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
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x'
    },
    {
        'neovim/nvim-lspconfig'
    },
    {
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        lazy = false,
        priority = 999
    },
    {
        "hrsh7th/cmp-path",
    },
    {
        'williamboman/mason.nvim'
    },
    {
        'williamboman/mason-lspconfig.nvim'
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
}
