return {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
        local context = require("treesitter-context")
        context.setup()
        vim.keymap.set("n", "[c", function()
            context.go_to_context(vim.v.count1)
        end, { silent = true })
    end
}
