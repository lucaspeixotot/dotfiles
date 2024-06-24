return {
    'echasnovski/mini.notify',
    version = '*',
    config = function()
        local notify = require("mini.notify")
        notify.setup({})
    end
}
