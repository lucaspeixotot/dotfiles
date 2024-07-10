return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        local nmap_leader = function(suffix, rhs, desc)
            vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
        end


        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                json = { "jq" }
            },
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            },

            nmap_leader("if", ":lua require('conform').format()<cr>", "Format file")
        })
    end,
}
