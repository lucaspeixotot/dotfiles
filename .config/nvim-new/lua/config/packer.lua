-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' }, { "nvim-telescope/telescope-live-grep-args.nvim" } }
    }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('nvim-lua/plenary.nvim')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }

    -- use {
    --     'phaazon/hop.nvim',
    --     branch = 'v2'
    -- }

    use {
        'numToStr/Comment.nvim',
    }

    -- Packer
    use 'sindrets/winshift.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'https://gitlab.com/yorickpeterse/nvim-window.git'

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly'                    -- optional, updated every week. (see issue #1193)
    }

    use { "windwp/nvim-autopairs" }
    use { "windwp/nvim-ts-autotag" }

    use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

    use { "SmiteshP/nvim-navic" }

    use { "nvim-tree/nvim-web-devicons" }

    use({
        "utilyre/barbecue.nvim",
        tag = "*",
    })

    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    }

    use { 'stevearc/aerial.nvim' }

    use { 'mattn/emmet-vim' }

    use { 'mrshmllow/document-color.nvim', config = function()
        require("document-color").setup {
            -- Default options
            mode = "background", -- "background" | "foreground" | "single"
        }
    end
    }

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })

    use { 'echasnovski/mini.nvim', branch = 'stable' }

    use { 'norcalli/nvim-colorizer.lua' }

    use {
        "nvim-neorg/neorg",
        config = function()
            require('neorg').setup {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                personal = "~/notes/personal",
                                portfolio = "~/notes/portfolio",
                            },
                        },
                    },
                },
            }
        end,
        requires = "nvim-lua/plenary.nvim",
    }

    use { "folke/which-key.nvim" }

    use({
        "jackMort/ChatGPT.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

    use('mg979/vim-visual-multi')

    use {
        "danymat/neogen",
        config = function()
            require('neogen').setup {}
        end,
        requires = "nvim-treesitter/nvim-treesitter",
        -- Uncomment next line if you want to follow only stable versions
        -- tag = "*"
    }
end)
