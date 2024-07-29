return {
    "lucaspeixotot/snipe.nvim",
    branch = "feature/pattern-files",
    config = function()
        local snipe = require("snipe")
        snipe.setup()
        nmap_g("b", ':lua require("snipe").current_buffers_toggle()<cr>', "Snipe current buffers")
        nmap_g("p", ':lua require("snipe").pattern_files_toggle()<cr>', "Snipe pattern buffers")
        nmap_leader("up", function() snipe.update_pattern() end, "Snipe pattern update")
    end
}
