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

-- Move text up and down
vim.keymap.set("v", "<A-k>", ":mz:m-2<cr>`z")
vim.keymap.set("v", "<A-j>", ":mz:m+<cr>`z")
vim.keymap.set("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
vim.keymap.set("x", "<A-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
vim.keymap.set("x", "<A-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- Terminal --
-- Better terminal navigation
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")

-- Emacs insert mode --
-- vim.keymap.set("i", "<C-a>", "<ESC>I")
-- vim.keymap.set("i", "<C-e>", "<ESC>A")
-- vim.keymap.set("i", "<M-f>", "<ESC><Space>wi")
-- vim.keymap.set("i", "<M-b>", "<ESC>bi")
-- vim.keymap.set("i", "<M-d>", "<ESC>cW")

-- Hop
vim.keymap.set('n', 'gs', "<cmd>lua require'hop'.hint_lines({multi_windows=true})<cr>")
vim.keymap.set('n', 'ga', "<cmd>lua require'hop'.hint_char1({current_line_only = false, multi_windows=true})<cr>")

-- Navigation
vim.keymap.set('n', "J", "mzJ`z")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")

-- yank to PC clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
