return {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap', 'mfussenegger/nvim-dap-python' },
    opts = {
        -- Your options go here
        -- name = "venv",
        -- auto_refresh = false
    },
    branch = "regexp",
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    config = function()
        local venvselector = require("venv-selector")
        venvselector.setup({
            settings = {
                options = {
                    debug = false
                },
                search = {
                    my_venvs = {
                        command = "fdfind '/bin/python$' /usr/local/lib --full-path"
                    }
                }
            }
        })
        nmap_leader("v", "<cmd>VenvSelect<cr>", "Open venv selector")
    end
}
