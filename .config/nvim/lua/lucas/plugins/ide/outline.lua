return {
    "hedyhli/outline.nvim",
    config = function()
        require("outline").setup({
            outline_window = {
                focus_on_open = false,
                position = 'left'
            },
        })
        nmap_leader("a", "<cmd>Outline<CR>", "Toggle outline")
    end,
}
