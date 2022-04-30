local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

keymap("n", "<leader><cr>", ":nohl<cr>", opts)
-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "fd", "<ESC>", opts)
keymap("v", "fd", "<ESC>gV", opts)
keymap("x", "fd", "<ESC>", opts)
keymap("c", "fd", "<C-C><Esc>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-k>", ":mz:m-2<cr>`z", opts)
keymap("v", "<A-j>", ":mz:m+<cr>`z", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":m'>+<cr>`<my`>mzgv`yo`z", opts)
keymap("x", "<A-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- Telescope
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({previewer = false }))<cr>", opts)
keymap("n", "<leader>fm", "<cmd>Telescope harpoon marks<cr>", opts)

keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>q", ":q<cr>", opts)


-- Emacs insert mode --
keymap("i", "<C-a>", "<ESC>I", opts)
keymap("i", "<C-e>", "<ESC>A", opts)
keymap("i", "<M-f>", "<ESC><Space>wi", opts)
keymap("i", "<M-b>", "<ESC>bi", opts)
keymap("i", "<M-d>", "<ESC>cW", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Bufferline
keymap("n", "<leader>xb", ":BufferLinePick<cr>", opts)

-- Java
keymap("n", "<leader>jo", "<cmd>lua require'jdtls'.organize_imports()<cr>", opts)

-- Formatting
keymap("n", "<leader>cf", "<cmd> lua vim.lsp.buf.formatting_sync()<cr>", opts)

-- Hop
keymap('n', '<leader>al', "<cmd>lua require'hop'.hint_lines({multi_windows=true})<cr>", opts)
keymap('n', '<leader>aa', "<cmd>lua require'hop'.hint_char2({current_line_only = false, multi_windows=true})<cr>", opts)
keymap('n', '<leader>aw', "<cmd>lua require'hop'.hint_words({current_line_only = false, multi_windows=true})<cr>", opts)
keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})

-- Win shift
vim.cmd[[
" Start Win-Move mode:
"nnoremap <C-W><C-M> <Cmd>WinShift<CR>
"nnoremap <C-W>m <Cmd>WinShift<CR>

" Swap two windows:
nnoremap <C-W>X <Cmd>WinShift swap<CR>

" If you don't want to use Win-Move mode you can create mappings for calling the
" move commands directly:
nnoremap <C-M-H> <Cmd>WinShift left<CR>
nnoremap <C-M-J> <Cmd>WinShift down<CR>
nnoremap <C-M-K> <Cmd>WinShift up<CR>
nnoremap <C-M-L> <Cmd>WinShift right<CR>
]]

-- Nvim-window
keymap('n', '<leader>o', '<cmd>lua require("nvim-window").pick()<cr>', opts)


-- Harpoon
keymap('n', '<leader>ma', '<cmd>lua require("harpoon.mark").add_file()<cr>', opts)
keymap('n', '<leader>mt', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', opts)
keymap('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', opts)
keymap('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', opts)
keymap('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', opts)
keymap('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', opts)


-- Hlslens
keymap('n', 'n',[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)

