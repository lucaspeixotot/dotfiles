vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")

-- Emacs insert mode --
vim.keymap.set("i", "<C-a>", "<ESC>I")
vim.keymap.set("i", "<C-e>", "<ESC>A")
vim.keymap.set("i", "<M-f>", "<ESC><Space>wi")
vim.keymap.set("i", "<M-b>", "<ESC>bi")
vim.keymap.set("i", "<M-d>", "<ESC>cW")

-- yank to PC clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
