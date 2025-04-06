return {
    "echasnovski/mini.extra",
    version = "*",
    config = function()
        local extra = require("mini.extra")
        nmap_leader("fe", ":Pick explorer cwd='.'<CR>", "Pick explorer")
        nmap_leader("fs", ":Pick lsp scope='workspace_symbol'<CR>", "Pick symbol")
        nmap_leader("fdc", ":Pick diagnostic scope='current'<CR>", "Pick diagnostic current file")
        nmap_leader("fdg", ":Pick diagnostic<CR>", "Pick diagnostic global")
        extra.setup({})
    end,
}
