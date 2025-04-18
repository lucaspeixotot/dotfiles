return {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = {
        'kevinhwang91/promise-async',
        'luukvbaal/statuscol.nvim',
    },
    init = function()
        -- vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        -- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep:|,foldclose:'
    end,
    config = function()
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end,
        })
    end,
}
