local nmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

local vmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('v', '<Leader>' .. suffix, rhs, { desc = desc })
end

nmap_leader("pv", vim.cmd.Ex, "")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Insert -
-- Press jk fast to enter
vim.keymap.set("i", "fd", "<ESC>")
vim.keymap.set("v", "fd", "<ESC>gV")
vim.keymap.set("x", "fd", "<ESC>")
vim.keymap.set("c", "fd", "<C-C><Esc>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Quick save and quit
nmap_leader("w", ":w<cr>", "Quick save")
nmap_leader("q", ":q<cr>", "Quick quit")

-- Emacs insert mode --
vim.keymap.set("i", "<C-a>", "<ESC>I")
vim.keymap.set("i", "<C-e>", "<ESC>A")
vim.keymap.set("i", "<M-f>", "<ESC><Space>wi")
vim.keymap.set("i", "<M-b>", "<ESC>bi")
vim.keymap.set("i", "<M-d>", "<ESC>cW")

-- yank to PC clipboard
nmap_leader("y", '"+y', "")
vmap_leader("y", '"+y', "")
nmap_leader("Y", '"+Y', "")

nmap_leader("d", '"_d', "")
vmap_leader("d", '"_d', "")
