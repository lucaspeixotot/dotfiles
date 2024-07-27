return {
    'viocost/viedit',
    config = function()
        local viedit = require('viedit')
        viedit.setup({
            override_keys = true,
            keys = {
                next_ocurrence = "n",
                previous_ocurrence = "N"
            }
        })
        nmap("=", '<cmd>lua require("viedit").toggle_all()<CR>', 'viedit mode')
        vmap("=", '<cmd>lua require("viedit").toggle_all()<CR>', 'viedit mode')
        nmap_leader("rr", '<cmd>lua require("viedit").reload()<CR>', 'vedit mode reload')
        nmap_leader("rf", '<cmd>lua require("viedit").restrict_to_function()<CR>', 'restrict to function')
        nmap_leader("rt", '<cmd>lua require("viedit").toggle_single()<CR>', 'toggle single occurrence')
    end
}
