return {
    "echasnovski/mini.files",
    version = "*",
    config = function()
        local files = require("mini.files")
        files.setup({})
        nmap_leader("e", ":lua MiniFiles.open()<cr>", "Mini files")
    end,
}
