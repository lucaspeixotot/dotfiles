vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.guicursor = ""

vim.opt.cmdheight = 2          -- more space in the neovim command line for displaying messages
vim.opt.smartcase = true       -- smart case
vim.opt.smartindent = true     -- make indenting smarter agai
vim.opt.splitbelow = true      -- force all horizontal splits to go below current window
vim.opt.splitright = true      -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false       -- creates a swapfile
vim.opt.undofile = true        -- enable persistent undo
vim.opt.updatetime = 300       -- faster completion (4000ms default)
vim.opt.writebackup = false    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true       -- convert tabs to spaces
vim.opt.shiftwidth = 4         -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4            -- insert 2 spaces for a tab
vim.opt.cursorline = false     -- do not highlight the current line
vim.opt.number = true          -- set numbered lines
vim.opt.relativenumber = false -- set relative numbered lines
vim.opt.wrap = false           -- display lines as one long line
vim.opt.scrolloff = 8          -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.undodir = os.getenv("HOME") .. "/config/nvim/undodir"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"
vim.cmd([[set laststatus=3]])
vim.cmd([[highlight WinSeparator guibg=None]])
vim.cmd([[syntax on]])
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    callback = function()
        local filepath = vim.fn.expand("%:p")
        if filepath:match("/fw%-ci/") then
            vim.opt_local.expandtab = false -- Use tabs, not spaces
            vim.opt_local.tabstop = 8       -- Set tab width to 8 spaces
            vim.opt_local.shiftwidth = 8    -- Indentation level = 8 spaces
            vim.opt_local.softtabstop = 8   -- Make backspace treat tabs as 8 spaces
        end
    end,
})
