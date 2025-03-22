return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        nmap_g("i", ":lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
        nmap_g("f", ":lua vim.lsp.buf.definition()<cr>", "Go to definition")
        nmap_g("d", ":lua vim.lsp.buf.declaration()<cr>", "Go to declaration")
        nmap_g(
            "rs",
            function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end,
            "Find workspace symbols"
        )

        nmap_g(
            "rr",
            function() vim.lsp.buf.references() end,
            "Go to references"
        )

        nmap_g(
            "ra",
            function() vim.lsp.buf.code_action() end,
            "Code action"
        )

        nmap_g(
            "rv",
            function() vim.lsp.buf.rename() end,
            "Rename symbol"
        )

        local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                },
            }
        })
        lspconfig.gopls.setup({})
        lspconfig.pyright.setup({
            settings = {
                python = {
                    analysis = {
                        extraPaths = { "./app" },
                        typeCheckingMode = "off"
                    }
                }
            }
        })
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        lspconfig.terraformls.setup({})
    end,
}
