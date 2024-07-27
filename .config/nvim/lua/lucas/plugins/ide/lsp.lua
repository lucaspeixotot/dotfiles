return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.gopls.setup({})
        lspconfig.pyright.setup({})
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        lspconfig.jdtl.setup({})

        nmap_g("r", ":lua vim.lsp.buf.references()<cr>", "Go to references")
        nmap_g("i", ":lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
        nmap_g("f", ":lua vim.lsp.buf.definition()<cr>", "Go to definition")
    end,
}
