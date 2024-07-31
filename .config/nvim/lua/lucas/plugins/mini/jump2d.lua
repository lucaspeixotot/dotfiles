return {
    "echasnovski/mini.jump2d",
    version = "*",
    config = function()
        local jump2d = require("mini.jump2d")
        jump2d.setup({})

        nmap("<CR>", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>", "Jump2d single character")
        -- nmap("<CR>", "<Cmd>lua MiniJump2d.start()<CR>", "Jump2d single character")
        nmap_g("l", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.line_start)<CR>", "Jump2d line")
    end,
}
