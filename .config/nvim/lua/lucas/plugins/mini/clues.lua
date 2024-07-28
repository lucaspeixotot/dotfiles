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
                -- Session clues
                { mode = "n", keys = "<leader>s", desc = "+SESSIONS" },
                -- Viedit clues
                { mode = "n", keys = "<leader>r", desc = "+VIEDIT" },
                -- Utils clues
                { mode = "n", keys = "<leader>u", desc = "+UTILS" },
                -- Pick clues
                { mode = "n", keys = "<leader>f", desc = "+PICK" },
                -- Debug clues
                { mode = "n", keys = "<leader>d", desc = "+DEBUG" },

            },
        })
    end
}
