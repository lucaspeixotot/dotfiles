return {
    "echasnovski/mini.pick",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local pick = require("mini.pick")
        local builtin = require("mini.pick").builtin
        require("nvim-web-devicons").setup({})

        pick.setup({})

        nmap_leader("ff", builtin.files, "Find files")
        nmap_leader("fg", builtin.grep_live, "Find Grep")
        nmap_leader("fb", builtin.buffers, "Find buffers")
    end,
}
