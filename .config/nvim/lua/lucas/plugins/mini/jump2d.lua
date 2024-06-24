return {
    'echasnovski/mini.jump2d',
    version = '*',
    config = function()
        local jump2d = require("mini.jump2d")
        local builtin = require("mini.jump2d").builtin
        jump2d.setup({})

        vim.keymap.set('n', '<CR>', '<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>')
    end
}
