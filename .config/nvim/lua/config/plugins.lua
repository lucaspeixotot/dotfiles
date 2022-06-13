local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and Treesitter
    use "numToStr/Comment.nvim" -- Easily comment stuff
    use "kyazdani42/nvim-tree.lua" -- Tree file manager
    use "akinsho/bufferline.nvim" -- Bufferline stuff
    use "moll/vim-bbye" -- Buffer stuff
    use "akinsho/toggleterm.nvim" -- Neovim terminal
    use {
        "phaazon/hop.nvim",
        branch = 'v1', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    } -- Like Avy emacs plugin
    use "tpope/vim-surround" -- cs'" stuff
    use "jalvesaq/Nvim-R" -- R support
    use "lewis6991/impatient.nvim" -- Improve startup time
    use "lukas-reineke/indent-blankline.nvim" -- Fancy indent lines
    use "antoinemadec/FixCursorHold.nvim"
    use "sindrets/winshift.nvim" -- Reorganize windows
    use "https://gitlab.com/yorickpeterse/nvim-window.git" -- C-x o emacs jump window
    use "ThePrimeagen/harpoon" -- Better file navigation (avoid multiple fuzzy find files)
    use "nkakouros-original/numbers.nvim" -- Relative lines
    use "petertriho/nvim-scrollbar" -- add scrollbar with diagnostics
    use "kevinhwang91/nvim-hlslens" -- add highlight to searches
    use {
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
    }
    use "stevearc/aerial.nvim"

    -- Colorscheme
    use 'folke/tokyonight.nvim'
    use 'norcalli/nvim-colorizer.lua'

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- cmp plugins
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    -- use {'tzachar/cmp-tabnine', requires = 'hrsh7th/nvim-cmp'}

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "mfussenegger/nvim-jdtls" -- Java development improvement
    use "jose-elias-alvarez/null-ls.nvim" -- Add linter and formatter for LSP
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons"
    } -- Fancy error diagnostics
    use "jose-elias-alvarez/nvim-lsp-ts-utils"

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    use 'nvim-telescope/telescope-media-files.nvim'

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow"
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use "nvim-treesitter/playground"

    -- Git
    use "lewis6991/gitsigns.nvim" -- Git signs before line number
    use "https://github.com/rhysd/conflict-marker.vim" -- Fancy solve git conflict

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
