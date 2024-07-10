return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local nmap_leader = function(suffix, rhs, desc)
            vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
        end

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        nmap_leader("ha", function()
            harpoon:list():add()
        end, "Add file")

        nmap_leader("hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, "Open menu")

        nmap_leader("1", function()
            harpoon:list():select(1)
        end, "Select 1")

        nmap_leader("2", function()
            harpoon:list():select(2)
        end, "Select 2")

        nmap_leader("3", function()
            harpoon:list():select(3)
        end, "Select 3")


        nmap_leader("4", function()
            harpoon:list():select(4)
        end, "Select 4")

        nmap_leader("5", function()
            harpoon:list():select(5)
        end, "Select 5")


        nmap_leader("6", function()
            harpoon:list():select(6)
        end, "Select 6")


        nmap_leader("7", function()
            harpoon:list():select(7)
        end, "Select 7")

        nmap_leader("8", function()
            harpoon:list():select(8)
        end, "Select 8")


        nmap_leader("9", function()
            harpoon:list():select(9)
        end, "Select 9")

        nmap_leader("0", function()
            harpoon:list():select(10)
        end, "Select 10")

        -- Toggle previous & next buffers stored within Harpoon list
        -- vim.keymap.set("n", "<leader>[", function()
        -- 	harpoon:list():prev()
        -- end)
        -- vim.keymap.set("n", "<leader>]", function()
        -- 	harpoon:list():next()
        -- end)
    end,
}
