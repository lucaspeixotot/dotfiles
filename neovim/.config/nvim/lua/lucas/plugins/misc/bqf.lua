return {
    "kevinhwang91/nvim-bqf",
    config = function()
        local bqf = require("bqf")
        bqf.setup({
            preview = {
                winblend = 0
            }
        })
    end,
}
