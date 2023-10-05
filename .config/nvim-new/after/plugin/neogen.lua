require('neogen').generate()

vim.keymap.set("n", "<leader>pd", ":lua require('neogen').generate()<CR>")
