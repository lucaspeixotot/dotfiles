return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup{}
        lspconfig.gopls.setup{}
        lspconfig.pyright.setup{}
        lspconfig.bashls.setup{}
        lspconfig.clangd.setup{}
        lspconfig.jdtl.setup{}
    end
}
