return {
    "echasnovski/mini.trailspace",
    version = "*",
    config = function()
        local trailspace = require("mini.trailspace")
        trailspace.setup({})

        nmap_leader(
            "ut",
            function()
                trailspace.trim()
            end,
            "Trim all whitespaces"
        )
    end,
}
