return {
    "oysandvik94/curl.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local curl = require("curl")
        curl.setup({
            mappings = {
                execute_curl = "<F2>"
            }
        })
    end
}
