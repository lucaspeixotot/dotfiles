return {
    "echasnovski/mini.extra",
    version = "*",
    config = function()
        local extra = require("mini.extra")
        vim.keymap.set("n", "<leader>fe", ":Pick explorer cwd='.'<CR>", {})
        vim.keymap.set("n", "<leader>fs", ":Pick lsp scope='document_symbol'<CR>", {})
        vim.keymap.set("n", "<leader>fd", ":Pick diagnostic scope='current'<CR>", {})
        extra.setup({})
    end,
}
