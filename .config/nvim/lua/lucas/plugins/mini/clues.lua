return {
    'echasnovski/mini.clue',
    version = '*',
    config = function()
        local miniclue = require('mini.clue')
        miniclue.setup({
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
                -- Harpoon clues
                { mode = "n", keys = "<leader>h",  desc = "+Harpoon" },
                -- Aerial clues
                { mode = "n", keys = "<leader>a",  desc = "Aerial toggle" },
                -- Neotree clues
                { mode = "n", keys = "<leader>t",  desc = "Neotree open" },
                -- IDE clues
                { mode = "n", keys = "<leader>i",  desc = "+IDE" },
                { mode = "n", keys = "<leader>if", desc = "Format buffer" },
                -- Misc clues
                { mode = "n", keys = "<leader>o",  desc = "Window pick" },
                { mode = "n", keys = "<leader>w",  desc = "Save" },
                { mode = "n", keys = "<leader>q",  desc = "Quit" },
                { mode = "n", keys = "<leader>=",  desc = "Neovim config" },
                -- Pick clues
                { mode = "n", keys = "<leader>f",  desc = "+Pick (find)" },
                { mode = "n", keys = "<leader>ff", desc = "Pick files" },
                { mode = "n", keys = "<leader>fb", desc = "Pick buffers" },
                { mode = "n", keys = "<leader>fg", desc = "Pick grep" },
                { mode = "n", keys = "<leader>fe", desc = "Pick explorer" },
                { mode = "n", keys = "<leader>fs", desc = "Pick lsp" },
                { mode = "n", keys = "<leader>fd", desc = "Pick diagnostics" },
                { mode = "n", keys = "<leader>fh", desc = "Pick history" },
                { mode = "n", keys = "<leader>fp", desc = "Pick git hunks" },


            },
        })
    end
}
