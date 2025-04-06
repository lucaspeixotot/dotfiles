return {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = function()
        local conflict = require("git-conflict")
        conflict.setup(
            {
                default_mappings = false,    -- disable buffer local mapping created by this plugin
                default_commands = true,     -- disable commands created by this plugin
                disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
                list_opener = 'copen',       -- command or function to open the conflicts list
                highlights = {               -- They must have background color, otherwise the default color will be used
                    incoming = 'DiffAdd',
                    current = 'DiffText',
                }
            }
        )

        nmap_leader('co', '<Plug>(git-conflict-ours)', "Git conflict action: Choose ours")
        nmap_leader('ct', '<Plug>(git-conflict-theirs)', "Git conflict action: Choose theirs")
        nmap_leader('cb', '<Plug>(git-conflict-both)', "Git conflict action: Choose both")
        nmap_leader('c0', '<Plug>(git-conflict-none)', "Git conflict action: Choose none")
        nmap_leader('cl', ':GitConflictListQf<CR>', "Git conflict action: Choose none")
    end

}
