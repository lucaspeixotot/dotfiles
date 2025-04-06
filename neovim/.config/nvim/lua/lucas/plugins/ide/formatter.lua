return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                json = { "jq" },
                sh = { "shfmt" }
            },
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            nmap_g("rf", ":lua require('conform').format()<cr>", "Format file")
        })
        -- conform.formatters.shfmt = {
        --     prepend_args = { "-i", "0", "-ci", "-sr", "-kp", "-s" }
        -- }
    end,
}
